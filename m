From: jim owens <jowens@hp.com>
Subject: Re: UI issues around RAID1
Date: Mon, 16 Nov 2009 16:48:31 -0500
Message-ID: <4B01C8AF.5040308@hp.com>
References: <adapr7ib96f.fsf@roland-alpha.cisco.com> <20091116202043.GA9779@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>, Roland Dreier <rdreier@cisco.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091116202043.GA9779@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik wrote:
> On Mon, Nov 16, 2009 at 10:45:28AM -0800, Roland Dreier wrote:
>>  - The free space reporting doesn't seem to take into account the fact
>>    that everything is going to be mirrored; so "df" et al report the
>>    size of the filesystem and free space on the new filesystem as
>>    size(dev1) + size(dev2) -- if dev1 and dev2 are the same size then I
>>    would assume it should really be just size(dev1) for a fully-RAID1
>>    filesystem.  (Not sure in general what we should say for a
>>    metadata-only mirrored filesystem, since we don't really know in
>>    advance how much space we have exactly)
>>
> 
> Yeah df is just a fun ball of wax in many respects.  We don't take into account
> RAID and we don't subtrace space thats strictly for metadata, so there are
> several things that need to be fixed for df.  Thanks,

But as we have said many times... if we have different
raid types active on different files, any attempt to make
df report "raid adjusted numbers" instead of the current raw
total storage numbers is going to sometimes give wrong answers.

So I think it is dangerous to try.  The current output
may be ugly, but it is always consistent and explainable.

jim
