From: Hullen@t-online.de (Helmut Hullen)
Subject: feature request (was: kernel 3.3.4 damages filesystem (?))
Date: 10 May 2012 13:55:00 +0200
Message-ID: <C8aMDSo9CXB@helmut.hullen.de>
References: <201205101240.49200.Martin@lichtvoll.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201205101240.49200.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Martin,

Du meintest am 10.05.12:

[...]

>> Maybe we should evaluate the possiblility of such a "one file gets
>> on one disk" feature.
>>
>> Helmut Hullen has the use case: Many disks, totally non-critical but
>> nice-to-have data. If one disk dies, some *files* should lost, not
>> some *random parts of all files*.
>>
>> This could be accomplished by some userspace-tool that moves stuff
>> around, combined with "file pinning"-support, that lets the user
>> make sure a specific file is on a specific disk.

> Yeah, basically I think thats the whole point Helmut is trying to
> make.

Yes - that's the feature which I miss ...

> I am not sure whether that should be in userspace. It could be just
> an allocation mode like "raid0" or "single". Such as "single" as in
> one file is really on one disk and thats it.

What I'm dreaming for:

I have a bundle/cluster of (p.e.) 3 disks. When I remove 1 disk  
(accidently/planned/because of disk failure) then I'd be very pleased  
when the contents of the other disks is (mostly) still readable.

It's no fun restoring Terabytes ...

Yes - I know: that's no backup, that doesn't replace a backup.

Viele Gruesse!
Helmut
