From: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
Subject: R: Re: Create subvolume from a directory?
Date: Thu, 29 Mar 2012 13:30:21 +0200 (CEST)
Message-ID: <3185061.10324771333020621346.JavaMail.defaultUser@defaultHost>
Reply-To: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Cc: "Matthias G. Eckermann" <mge@suse.com>, Alex <alex@bpmit.com>,
	<linux-btrfs@vger.kernel.org>
To: <liubo2009@cn.fujitsu.com>, <kreijack@inwind.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Liubo

>----Messaggio originale----
>Da: liubo2009@cn.fujitsu.com
>Data: 29/03/2012 3.24

>> Could you elaborate which would be the issue ?
>> "cp --reflink"-ing a file is not different than snapshotting a file. In
>> any case I could mount a snapshot and not the source subvolume.
>> 
>
>We already have a debate about this "cross-link device":
>http://comments.gmane.org/gmane.comp.file-systems.btrfs/9864

I read the thread, but I didn't find any explanation for which it should be 
dangerous allowing a cross-link device cp--reflink. Christoph Hellwig only 
asked to explain the "btrfs subvolume semantics" to the fsdevel mailing list, 
in order to find "possible" conflict with the standard unix semantics. But 
because the Inode are different from source and dest I cannot see any problem 
(may be I am wrong, but please explain why).

The only fact that should be pointed out is that cross-link device is not 
possible in the general case; btrfs would be an exception. But I think that 
there are very good reasons to allow the btrfs-exception. But, I repeat, I 
didn't find any good reason to do not allow it. 

>"cp --reflink" will use clone feature, which can share data among files, but 
metadata is preserved individually.
>
>My case is that I can mount both a subvolume and a snapshot via "-o 
subvol=xxx" or "-o subvolid=xxx".

This should not be a problem. My usual setup is to mount a subvolume as root, 
and the real btrfs root inside a subdirectory to allow operation between 
subvolume (like snapshot and/or cp --reflink). Of course if I don't mount the 
btrfs root, I could not perform snapshot and/or cp --reflink.

>thanks,
>liubo
Ciao
Goffredo

