Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:19313 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752524Ab3K2CEz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Nov 2013 21:04:55 -0500
Message-ID: <5297F633.8090100@cn.fujitsu.com>
Date: Fri, 29 Nov 2013 10:04:35 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.net>
CC: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        Alex Lyakas <alex.btrfs@zadarastorage.com>
Subject: Re: [PATCH] btrfs-progs: add options to sync filesystem after subvol
 delete
References: <1385657947-26145-1-git-send-email-dsterba@suse.cz> <20131129013638.01ede78a@natsu>
In-Reply-To: <20131129013638.01ede78a@natsu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/29/2013 03:36 AM, Roman Mamedov wrote:
> On Thu, 28 Nov 2013 17:59:07 +0100
> David Sterba <dsterba@suse.cz> wrote:
>
>> Subvolume deletion does not do a full transaction commit. This can lead
>> to an unexpected result when the system crashes between deletion and
>> commit, the subvolume directory will appear again. Add options to request
>> filesystem sync after each deleted subvolume or after the last one.
>>
>> If the command with sync option finishes succesfully, the subvolume(s)
>> deletion status is safely stored on the media.
> A feature that people pretty often request, is a way to delete a subvolume,
> and have some way to "sync", i.e. pause execution of their script until all
> the space freed up by the deletion has been recovered and made available (e.g.
> for the next round of their backup to run).
>
> Does this patch now make this possible?
My understanding here is:

No, deleting subvolume is 'async'. this patch only gurantee that
subvolume deletion status is on-disk, but subvolume deletion work
still have not finished, it will run in the backgroud, if a crash happens,
the work will continue after rebooting.

>
> Also, did you consider enhancing "btrfs fi sync" to sync the snapshot deletion
> (it currently doesn't), rather than adding the "sync" options to deletion
> itself? E.g. comparing to traditional tools, people would logically do:
>
>    $ rm /some/dir/some/file
>    $ sync
>
> rather than something akin to
>
>    $ rm --sync /some/dir/some/file
>
subvolume deletion is a little different from command 'rm'.
To delete a subvolume, we have to run:
btrfs sub delete  <subv>

If you run 'btrfs file sync' after 'btrfs sub delete' it will have same
effect as david's 'btrfs sub delete --sync'  i think.

Thanks,
Wang


