Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:23175 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753122Ab3LBJDP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Dec 2013 04:03:15 -0500
Message-ID: <529C4CB9.8020403@cn.fujitsu.com>
Date: Mon, 02 Dec 2013 17:02:49 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: dsterba@suse.cz, Roman Mamedov <rm@romanrm.net>,
        linux-btrfs@vger.kernel.org,
        Alex Lyakas <alex.btrfs@zadarastorage.com>
Subject: Re: [PATCH] btrfs-progs: add options to sync filesystem after subvol
 delete
References: <1385657947-26145-1-git-send-email-dsterba@suse.cz> <20131129013638.01ede78a@natsu> <5297F633.8090100@cn.fujitsu.com> <20131129173744.GP25312@suse.cz>
In-Reply-To: <20131129173744.GP25312@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Dave,

On 11/30/2013 01:37 AM, David Sterba wrote:
> On Fri, Nov 29, 2013 at 10:04:35AM +0800, Wang Shilong wrote:
>>>> Subvolume deletion does not do a full transaction commit. This can lead
>>>> to an unexpected result when the system crashes between deletion and
>>>> commit, the subvolume directory will appear again. Add options to request
>>>> filesystem sync after each deleted subvolume or after the last one.
>>>>
>>>> If the command with sync option finishes succesfully, the subvolume(s)
>>>> deletion status is safely stored on the media.
>>> A feature that people pretty often request, is a way to delete a subvolume,
>>> and have some way to "sync", i.e. pause execution of their script until all
>>> the space freed up by the deletion has been recovered and made available (e.g.
>>> for the next round of their backup to run).
>>>
>>> Does this patch now make this possible?
>> My understanding here is:
>>
>> No, deleting subvolume is 'async'. this patch only gurantee that
>> subvolume deletion status is on-disk, but subvolume deletion work
>> still have not finished, it will run in the backgroud, if a crash happens,
>> the work will continue after rebooting.
> That's right, but also shows that there are different notions what the
> sync could mean and both make sense and should be implemented.
>
> Waiting for the subvolume until it's completely deleted can be now
> implemented by polling the dead root key. The subvolume deletion ioctl
> takes only the path but no flags so it cannot be extended that way.
>
>>> Also, did you consider enhancing "btrfs fi sync" to sync the snapshot deletion
>>> (it currently doesn't), rather than adding the "sync" options to deletion
>>> itself? E.g. comparing to traditional tools, people would logically do:
>>>
>>>    $ rm /some/dir/some/file
>>>    $ sync
>>>
>>> rather than something akin to
>>>
>>>    $ rm --sync /some/dir/some/file
>>>
>> subvolume deletion is a little different from command 'rm'.
>> To delete a subvolume, we have to run:
>> btrfs sub delete  <subv>
>>
>> If you run 'btrfs file sync' after 'btrfs sub delete' it will have same
>> effect as david's 'btrfs sub delete --sync'  i think.
> Yeah, it's different but extending 'fi sync' to wait for subvolume
> cleaning is a valid usecase.
>
> So an enahced interface could look like this:
>
> subvol delete:
> --commit-each - run the ioc sync/wait ioctl after each delete ioctl
> --commit-after - dtto but sync/wait after all are deleted
> --wait-for-cleanup - wait until all given subvols are cleaned
>
> 'filesystem sync' exteded to wait for subvol cleanup has following
> cases:
> - wait for a specific subvolume to be cleaned
> - wait for all currently deleted, do not care if more subvols are
>    deleted in the meantime
> - wait until there are no subvolumes left to clean
I think it is unnecessary to add such options for 'filesystem sync'.
we may wait a long time until all subvolume deletion are finished as
async subvolume deletion is implemented in cleaner thread.:-)

Miao also pointed out that only if we are running out of space, waiting
subvolume deletion finished will make sense, our opinion is not to disturb
'filesystem sync' .

What do you think ? :-)

Thanks,
Wang
>
> Are there more usecases to cover?
>
>
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

