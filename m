Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52950 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751275AbdCQW1r (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Mar 2017 18:27:47 -0400
Subject: Re: [PULL] Btrfs updates for 4.11-rc2
To: David Sterba <dsterba@suse.com>
References: <cover.1489067273.git.dsterba@suse.com>
CC: <linux-btrfs@vger.kernel.org>
From: Chris Mason <clm@fb.com>
Message-ID: <3f581fad-8100-efeb-9cb8-a947804bcc3c@fb.com>
Date: Fri, 17 Mar 2017 16:56:54 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1489067273.git.dsterba@suse.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/09/2017 08:55 AM, David Sterba wrote:
> Hi,
>
> there's a regression fix for the assertion failure reported by Dave Jones, the
> rest of patches are minor updates. Please pull, thanks.
>
> The following changes since commit e9f467d028cd7d8bee2a4d6c4fb806caf8cd580b:
>
>   Merge branch 'for-chris-4.11-part2' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux into for-linus-4.11 (2017-02-28 14:35:09 -0800)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-chris-4.11-rc2
>
> for you to fetch changes up to 94b5a2924fc0ec2bb2347ca31156be8fabe907c4:
>
>   Btrfs: consistent usage of types in balance_args (2017-03-09 14:23:00 +0100)
>

Thanks Dave, these all tested well all week, but a few were arguably 
cleanups.  I've pull out the fixes only for this time and I'll queue the 
others for 4.12.

-chris

