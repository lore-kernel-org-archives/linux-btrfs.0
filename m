From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH v4 4/6] btrfs: sync scrub with commit & device removal
Date: Thu, 24 Mar 2011 13:58:52 +0100
Message-ID: <4D8B400C.7010102@gmx.net>
References: <cover.1300462778.git.sensille@gmx.net> <a791c7692d9c1eb5cbf111c01f5d94f42b904523.1300462778.git.sensille@gmx.net> <20110323172811.GH17108@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org, dave@jikos.cz
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110323172811.GH17108@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On 23.03.2011 18:28, David Sterba wrote:
> Hi,
> 
> you are adding a new smp_mb, can you please explain why it's needed and
> document it?
> 
> thanks,
> dave
> 
> On Fri, Mar 18, 2011 at 04:55:07PM +0100, Arne Jansen wrote:
>> This adds several synchronizations:
>>  - for a transaction commit, the scrub gets paused before the
>>    tree roots are committed until the super are safely on disk
>>  - during a log commit, scrubbing of supers is disabled
>>  - on unmount, the scrub gets cancelled
>>  - on device removal, the scrub for the particular device gets cancelled
>>

>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -1330,6 +1330,8 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
>>  		goto error_undo;
>>  
>>  	device->in_fs_metadata = 0;
>> +	smp_mb();
>         ^^^^^^^^

The idea was to disallow any new scrubs so start beyond
this point, but it turns out this is not strong enough.
I have to move the check for in_fs_metadata in btrfs_scrub_dev
inside the scrub_lock. In this case, the smp_mb is still needed,
as in_fs_metadata is not protected by any lock. I'll add a
comment.
Thanks for forcing me to rethink this :)

-Arne

> 
>> +	btrfs_scrub_cancel_dev(root, device);
>>  
>>  	/*
>>  	 * the device list mutex makes sure that we don't change


