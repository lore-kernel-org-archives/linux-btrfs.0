Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:38856 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab3AaK5Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 05:57:16 -0500
Received: by mail-ee0-f43.google.com with SMTP id c50so1427764eek.2
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2013 02:57:14 -0800 (PST)
Message-ID: <510A4DF5.8020308@statystyka.net>
Date: Thu, 31 Jan 2013 11:56:53 +0100
From: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Poor performance of btrfs. Suspected unidentified btrfs housekeeping
 process which writes a lot
References: <510934E6.7080302@statystyka.net> <6F302998-3D6E-4E91-9DDA-C475344B51BF@colorremedies.com> <5109C2A8.7090005@statystyka.net> <150353F1-2795-4FDD-A1F4-8F544813E7A0@colorremedies.com>
In-Reply-To: <150353F1-2795-4FDD-A1F4-8F544813E7A0@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My original problem got solved, but you answer has a set of interesting 
performance hints, and I am very grateful for you input. Here are my 
answers and further questions if you are willing to continue this topic.


On 2013-01-31 02:50, Chris Murphy wrote:
> On Jan 30, 2013, at 6:02 PM, Adam Ryczkowski <adam.ryczkowski@statystyka.net> wrote:
>
>>   I didn't take precise measurements, but I can tell, that reading 500 50-byte files (ca. 25kB of data) took way longer that reading one 3MB file, so I suspect the problem is with metadata access times rather than with data.
> For 50 byte files, btrfs writes the data with metadata. Depending on their location relative to each other, this could mean 250MB of reads because of the large raid6 chunk size, yet only ~ 2MB is needed by btrfs.
Yes, good point. I never stated that my setup gives me the best I can 
get from my hardware.
>> I am aware, that reading 1MB distributed in small files takes longer than 1MB of sequential reading. The problem is that _suddenly_ this speed  got at least 20 times longer than usual.
> How does dedup work on 50 byte files? How does it contribute to fragmentation? And then how does that fragmentation turn into gross read inefficiencies at the md chunk level?
I really don't know. It is interesting to know that, though. But 
whatever are the results, at the current state of affairs the defrag 
will ruin all benefits of bedup, so even if the filesystem gets 
fragmented, I can do nothing about it.
>> And from what iotop and systat told me, the harddrives were busy _writing_ something, not _reading_!
> Seems like you need to find out what's being written, how many and how big the requests are. Small writes mean huge RWM penalty on raid6, especially a 4 disk raid 6 where you're practically guaranteed to have either data or metadata request halted for a parity rewrite.
Yes, you are right. It is important contributing factor, why relatime 
mount option killed my performance so badly.
>> Anyway, I synchronize only the "working copy" part of my file system. All the backup subvolumes sit in a separate path, not seen by the unison.
> You're syncing what to what, in physical terms? I know one of the what's is a btrfs volume on top of LVM, on top of LUKs, on top of md raid6, on top of partitions located on four 3TB drives. YOu said there are other partitions on these drives so are there other read/writes occurring on those drives at the same time? It doesn't look like that's the case from iotop, the md0
No, I synchronize across network with my desktop machines and backup 
file server :-). But even if I didn't, the unison is kind enough to 
detect local sync and it makes them in sequence (not asynchronously).
>>> What's the chunk size for the raid 6? What's the btrfs leaf size? What's the dedup chunk size?
>> I'll tell you tomorrow, but I hardly think that the misalignment could be any problem here. As I said, everything was fine and the problem didn't appear in gradual fashion.
> It also depends on what mysterious stuff is being written during what's ostensibly a read only event.
The dedup chunk size isn't clearly stated, but from the README I infer 
it deduplicates files as a whole; here is an excerpt from the README 
(https://github.com/g2p/bedup/blob/master/README.rst)
> Deduplication is implemented using a Btrfs feature that allows for 
> cloning data from one file to the other. The cloned ranges become 
> shared on disk, saving space.

This is a summary of the granurality of the allocation pieces in the 
storage hierarchy.
On mdadm I have chunk size of 512K,
the dm-crypt volume uses 512 byte sectors,
and all lvm physical volumes' PE Sizes: 4MiB, but it shouldn't affect 
efficiency.

I couldn't find any command that tells me the leaf size of already 
created btrfs system. Maybe you can tell me?

I will also check, if there is an alignment problem as well. When I was 
reading a manual for each of the layer I came to the conclusion that 
each layer is supposed to align to the underlying one automatically. But 
I try to can check it.
>>> Why are you using LVM at all, while the /dev/dm-1 is the same size as the LV? You say the btrfs volume on LV is on dm-1 which means they're all the same size, obviating the need for LVM in this case entirely.
>> Yes, I agree, that at the moment I don't need it. But when partition sits on logical volume I keep the option to extend the filesystem, when I the need comes.
> This is not an ideal way to extend a btrfs file system however. You're adding unnecessarily layers and complexity while also not taking advantage of what LVM can do that btrfs cannot when it comes to logical volume management.
Can you tell me more? Because I have only learned, that btrfs 
multi-device support cannot join two volumes without striping. And 
striping in this case is equivalent to fragmentation, which we want to 
avoid. In contrast to what LVM can do. LVM can concatenate the 
underlying storage together, without striping.

-- 

Adam Ryczkowski
www.statystyka.net <http://www.google.com/>
+48505919892 <callto:+48505919892>
Skype:sisteczko <skype:sisteczko>
Aktualny kalendarz 
<https://www.google.com/calendar/b/0/embed?src=adam.ryczkowski@statystyka.net&ctz&gsessionid=OK>

