Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49775 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925Ab3JWCLt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 22:11:49 -0400
Message-ID: <5267305D.7030605@oracle.com>
Date: Wed, 23 Oct 2013 10:11:41 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, chris.mason@fusionio.com,
        jbacik@fusionio.com
Subject: Re: [PATCH 1/2] btrfs-progs: make get_btrfs_mount callable
References: <1382421202-18494-1-git-send-email-anand.jain@oracle.com> <20131022144346.GV1032@twin.jikos.cz>
In-Reply-To: <20131022144346.GV1032@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/22/13 10:43 PM, David Sterba wrote:
> On Tue, Oct 22, 2013 at 01:53:21PM +0800, Anand Jain wrote:
>> get_btrfs_mount is reusable function but it is printing
>> errors, this removes it. Here the parent function of
>> open_path_or_dev_mnt does print error msg on error.
>
> Yeah, but then each caller should duplicate the is_block_device check to
> keep get_btrfs_mount silent. There should be 2 functions, one that does
> all the error checking and prints error messages and one that is silent
> and usable eg. from a library. I'll keep the patch as-is for now because
> there are no other users than open_path_or_dev_mnt and the function is
> not exported to library.

  yeah. sounds good. certainly we do have opportunities
  when we are on the lib functions.

Thanks, Anand
