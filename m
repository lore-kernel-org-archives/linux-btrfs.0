Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40676 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S968003AbeF1TDw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 15:03:52 -0400
Date: Thu, 28 Jun 2018 20:26:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, Filipe Manana <fdmanana@gmail.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs updates for 4.18
Message-ID: <20180628182616.GK2287@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1528125657.git.dsterba@suse.com>
 <CAL3q7H7iLCPxA01811RJK-bEiRPAGJdTrHLogJr2a3Sq1g0k4g@mail.gmail.com>
 <e315b073-05f9-7280-d1ee-4d0456085720@oracle.com>
 <CAL3q7H6EwxMVCM7-cfwb119eCaYAaVo3Go64jE99Z9y04igV5w@mail.gmail.com>
 <20180611161508.GA24375@twin.jikos.cz>
 <ff25bbd0-33ce-4787-da4b-9025d381593a@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ff25bbd0-33ce-4787-da4b-9025d381593a@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 28, 2018 at 07:22:59PM +0800, Anand Jain wrote:
>   The circular locking dependency warning occurs at FSSTRESS_PROG.
>   And in particular at doproc() in xfstests/ltp/fsstress.c, randomly
>   at any of the command at
>   opdesc_t        ops[] = { ..}
>   which involves calling mmap file operation and if there is something
>   to commit.
> 
>   The commit transaction does need device_list_mutex which is also being
>   used for the btrfs_open_devices() in the commit 542c5908abfe84f7.
> 
>   But btrfs_open_devices() is only called at mount, and mmap() can
>   establish only be established after the mount has completed. With
>   this give its unclear to me why the circular locking dependency check
>   is warning about this.
> 
>   I feel until we have clarity about this and also solve other problem
>   related to the streamlining of uuid_mutex, I suggest we revert
>   542c5908abfe84f7. Sorry for the inconvenience.

Ok, the revert is one option. I'm cosidering adding both the locks, like
is in https://patchwork.kernel.org/patch/10478443/ . This would have no
effect, as btrfs_open_devices is called only from mount path and the
list_sort is done only for the first time when there are not other
users of the list that would not also be under the uuid_mutex.

This passed the syzbot and other tests, so this does not break things
and goes towards pushing the device_list_mutex as the real protection
mechanism for the fs_devices members.

Let me know what you think, the revert should be the last option if we
don't have anything better.
