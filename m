Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nm.newmedia-net.de ([217.113.179.122]:39473 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751596AbdATJ72 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jan 2017 04:59:28 -0500
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <7473ea27-9716-33fb-ecec-2ec52fac3820@dd-wrt.com>
 <pan$70181$45383b8f$72c6c22$19cae0fb@cox.net>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <506731b5-2eed-df19-0887-3f65dd52f93a@dd-wrt.com>
Date: Fri, 20 Jan 2017 10:59:24 +0100
MIME-Version: 1.0
In-Reply-To: <pan$70181$45383b8f$72c6c22$19cae0fb@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Subject: Re: btrfs recovery
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 20.01.2017 um 09:05 schrieb Duncan:
> Sebastian Gottschall posted on Thu, 19 Jan 2017 11:06:19 +0100 as
> excerpted:
>
>> I have a question. after a power outage my system was turning into a
>> unrecoverable state using btrfs (kernel 4.9)
>> since im running --init-extent-tree now for 3 days i'm asking how long
>> this process normally takes
> QW has the better direct answer for you, but...
>
> This is just a note to remind you, in general questions like "how long"
> can be better answered if we know the size of your filesystem, the mode
> (how many devices and what duplication mode for data and metadata) and
> something about how you use it -- how many subvolumes and snapshots you
> have, whether you have quotas enabled, etc.
hard to give a answer right now since the fs is still in 
init-tree-extent. so i cannot get any details from it while running this 
process.
it was a standard opensuse 42.1 installation with btrfs as rootfs. the 
size is about 1,8 tb. no soft raid. its a hardware raid6 system using a 
areca controller
running all as single device
> hr
>
> Normally output from commands like btrfs fi usage can answer most of the
> filesystem size and mode stuff, but of course that command requires a
> mount, and you're doing an unmounted check ATM.  However, btrfs fi show
> should still work and give us basic information like file size and number
> of devices, and you can fill in the blanks from there.
0:rescue:~ # btrfs.static fi show
Label: none  uuid: 946b1a04-c321-4a24-bfb4-d6dcfa8b52dc
         Total devices 1 FS bytes used 1.15TiB
         devid    1 size 1.62TiB used 1.37TiB path /dev/sda3

>
> You did mention the kernel version (4.9) however, something that a lot of
> reports miss, and you're current, so kudos for that. =:^)
i was reading other reports first, so i know whats expected :-)
beside this im a linux developer as well, so i know whats most important 
to know and most systems i run are almost up to date
>
> As to your question, assuming a terabyte scale filesystem, as QW
> suggested, a full extent tree rebuild is a big job and could indeed take
> awhile (days).
4992 minutes now so, 3.4 days
>
>  From a practical perspective...
>
> Given the state of btrfs as a still stabilizing and maturing filesystem,
> having backups for any data you value more than the time and hassle
> necessary to do the backup is even more a given than on a fully stable
> filesystem, which means, given the time for an extent tree rebuild on
> that size of a filesystem, unless you're doing the rebuild specifically
> to get the experience or test the code, as a practical matter it's
> probably simply easier to restore from that backup if you valued the data
> enough to have one, or simply scrap the filesystem and start over if you
> considered the data worth less than the time and hassle of a backup, and
> thus didn't have one.
i have a backup for sure for worst case, its just not always up to date. 
which means i might lost minor work of 6 -7 days maximum since i cannot 
mirror the whole filesystem every second
sourcecodes in repository are safe for sure and there will be nothing 
lost,but will take always some time to get the backup back to the 
system, reinstalling OS, etc. my OS is not very vanilla. its all
a little bit customized and not sure how i did it last time and would 
take some time to find the right path back. so its worth to try it 
without going the hard way
>


-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Berliner Ring 101, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565

