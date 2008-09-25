From: "Miguel Sousa Filipe" <miguel.filipe@gmail.com>
Subject: Re: feature request: read/write priorities on multiple devices/raid1
Date: Thu, 25 Sep 2008 16:31:41 +0100
Message-ID: <f058a9c30809250831r5479c4fcyac4deade9ddfda0e@mail.gmail.com>
References: <1553.85.177.90.248.1222334375.squirrel@webmail.schleiser.de>
	 <1222348238.7028.31.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Kaspar Schleiser" <kaspar@schleiser.de>,
	linux-btrfs@vger.kernel.org
To: "Chris Mason" <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1222348238.7028.31.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

On Thu, Sep 25, 2008 at 2:10 PM, Chris Mason <chris.mason@oracle.com> wrote:
> On Thu, 2008-09-25 at 11:19 +0200, Kaspar Schleiser wrote:
>> Hello everybody!
>>
>> This is my first post on the list, let me know if I'm not following any
>> rules.
>>
>> What do you think about adding priorities for raid1 arrays?
>>
>> For example, always use /dev/ram0 (ramdisk) for reading/writing, but
>> nonetheless write everything additionally on /dev/sda1. Restore to
>> /dev/ram0 after mount if it is empty.
>>
>
> I don't plan on adding support for non-persistent storage, but there
> will be the idea of a fast frontend device that is basically a cache for
> slower devices.

Something like yet another caching/buffer layer between the buffer
cache and the storage devices?

I recall reading something similiar to that in a listing of new
features of a recent revision of ZFS ?

-- 
Miguel Sousa Filipe
