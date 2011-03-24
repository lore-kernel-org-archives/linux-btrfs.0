From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH v4 3/6] btrfs: add scrub code and prototypes
Date: Thu, 24 Mar 2011 11:25:29 +0100
Message-ID: <4D8B1C19.7060105@gmx.net>
References: <cover.1300462778.git.sensille@gmx.net> <661b3135624735f82675abf6f3b59e1e931d0fce.1300462778.git.sensille@gmx.net> <20110323171833.GG17108@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org, dave@jikos.cz
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110323171833.GG17108@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On 23.03.2011 18:18, David Sterba wrote:
> Hi,
> 
> I'm reviewing the atomic counters and the wait/wake infrastructure,
> just found two missed mutex_unlock()s in btrfs_scrub_dev() in error
> paths.
> 
> On Fri, Mar 18, 2011 at 04:55:06PM +0100, Arne Jansen wrote:
>> This is the main scrub code.

>> +	mutex_lock(&fs_info->scrub_lock);
>> +	if (dev->scrub_device) {
>> +		mutex_unlock(&fs_info->scrub_lock);
> 		mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
> 
>> +		scrub_workers_put(root);
>> +		return -EINPROGRESS;
>> +	}
>> +	sdev = scrub_setup_dev(dev);
>> +	if (IS_ERR(sdev)) {
>> +		mutex_unlock(&fs_info->scrub_lock);
> 		mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
> 
>> +		scrub_workers_put(root);
>> +		return PTR_ERR(sdev);
>> +	}

Thanks, I'll add you as Reported-by if that's ok.

-Arne
