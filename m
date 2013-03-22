Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:35311 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943Ab3CVTKF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Mar 2013 15:10:05 -0400
Message-ID: <514CAC8D.7010409@profihost.ag>
Date: Fri, 22 Mar 2013 20:10:05 +0100
From: Stefan Priebe <s.priebe@profihost.ag>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: No space left on device (28)
References: <514ABEB8.3090104@profihost.ag> <20130321180020.30044.84729@localhost.localdomain> <967ED686-7E9C-4158-80A0-D58D18818BA2@profihost.ag> <20130321190249.30044.79438@localhost.localdomain> <514B62A4.1030201@profihost.ag> <5F36F35C-39BE-4244-B8FB-A80EC2B06D48@profihost.ag> <514C4A8C.90607@profihost.ag> <20130322135322.GB1955@localhost.localdomain> <514C6319.7030400@profihost.ag> <20130322155453.GD1955@localhost.localdomain>
In-Reply-To: <20130322155453.GD1955@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,
Am 22.03.2013 16:54, schrieb Josef Bacik:
> On Fri, Mar 22, 2013 at 07:56:41AM -0600, Stefan Priebe - Profihost AG wrote:
>> Hi Josef,
>> Am 22.03.2013 14:53, schrieb Josef Bacik:
>>> On Fri, Mar 22, 2013 at 06:11:56AM -0600, Stefan Priebe - Profihost AG wrote:
>>>> Hi Chris,
>>>>
>>>>>>>>> Which kernel are you running?
>>>>>>>>>
>>>>>>>>> -chris
>>>>>>>>
>>>>>>>> vanilla 3.8.3.
>>>>>>>
>>>>>>> Ok, with the 3.9 merge window Josef changed how we do the reservations.
>>>>>>> Are you able to try a slightly more experimental kernel?
>>>>
>>>> any ideas what i can check? 3.9-rc3 gives me same results.
>>>>
>>>
>>> Sorry Stefan I'm almost done with what I'm working on and then I'll work up a
>>> patch for you to run so I can narrow down what's going on.  Thanks,
>>
>> Great!
>>
>> Thanks - just wanted to know that it's not my fault. I'm happy to test
>> the patch and provide feedback.
>>
> Ok I think we are way over-reserving for rename, can you give this patch a whirl
> and see what happens?  If it still fails can you capture dmesg and reply with
> that so I can see what's going on.  Thanks,

Thanks for the patch. I was able to copy some files and i'm still able 
put it copy some then fails on some then copies some then fails on some.

Rsync output:
.software/kernel/linux-3.9-rc3/drivers/rtc/rtc-wm8350.c
        12156 100%   11.17kB/s    0:00:01 (xfer#21395, to-check=1008/52625)
.software/kernel/linux-3.9-rc3/drivers/rtc/rtc-x1205.c
        16460 100%   15.05kB/s    0:00:01 (xfer#21396, to-check=1007/52625)
.software/kernel/linux-3.9-rc3/drivers/rtc/systohc.c
         1223 100%    1.12kB/s    0:00:01 (xfer#21397, to-check=1006/52625)
.software/kernel/linux-3.9-rc3/drivers/s390/
.software/kernel/linux-3.9-rc3/drivers/s390/Makefile
          144 100%    0.13kB/s    0:00:01 (xfer#21398, to-check=1052/52672)
.software/kernel/linux-3.9-rc3/drivers/s390/block/
rsync: recv_generator: mkdir 
"/mnt/.software/kernel/linux-3.9-rc3/drivers/s390/block" failed: No 
space left on device (28)
*** Skipping any contents from this failed directory ***
.software/kernel/linux-3.9-rc3/drivers/s390/char/
rsync: recv_generator: mkdir 
"/mnt/.software/kernel/linux-3.9-rc3/drivers/s390/char" failed: No space 
left on device (28)
*** Skipping any contents from this failed directory ***
.software/kernel/linux-3.9-rc3/drivers/s390/cio/
rsync: recv_generator: mkdir 
"/mnt/.software/kernel/linux-3.9-rc3/drivers/s390/cio" failed: No space 
left on device (28)
rsync: mkstemp 
"/mnt/.software/kernel/linux-3.9-rc3/drivers/regulator/.88pm8607.c.YBi0Rz" 
failed: No space left on device (28)
*** Skipping any contents from this failed directory ***
.software/kernel/linux-3.9-rc3/drivers/s390/crypto/
rsync: recv_generator: mkdir 
"/mnt/.software/kernel/linux-3.9-rc3/drivers/s390/crypto" failed: No 
space left on device (28)
*** Skipping any contents from this failed directory ***
.software/kernel/linux-3.9-rc3/drivers/s390/kvm/
rsync: recv_generator: mkdir 
"/mnt/.software/kernel/linux-3.9-rc3/drivers/s390/kvm" failed: No space 
left on device (28)
*** Skipping any contents from this failed directory ***
.software/kernel/linux-3.9-rc3/drivers/s390/net/
rsync: recv_generator: mkdir 
"/mnt/.software/kernel/linux-3.9-rc3/drivers/s390/net" failed: No space 
left on device (28)
rsync: mkstemp 
"/mnt/.software/kernel/linux-3.9-rc3/drivers/regulator/.Kconfig.0lsfuE" 
failed: No space left on device (28)
*** Skipping any contents from this failed directory ***
rsync: mkstemp 
"/mnt/.software/kernel/linux-3.9-rc3/drivers/regulator/.Makefile.C9wI7I" 
failed: No space left on device (28)
.software/kernel/linux-3.9-rc3/drivers/s390/scsi/
rsync: recv_generator: mkdir 
"/mnt/.software/kernel/linux-3.9-rc3/drivers/s390/scsi" failed: No space 
left on device (28)
*** Skipping any contents from this failed directory ***
.software/kernel/linux-3.9-rc3/drivers/sbus/
.software/kernel/linux-3.9-rc3/drivers/sbus/Makefile
           70 100%    0.06kB/s    0:00:01 (xfer#21399, to-check=1003/52824)
.software/kernel/linux-3.9-rc3/drivers/sbus/char/
rsync: recv_generator: mkdir 
"/mnt/.software/kernel/linux-3.9-rc3/drivers/sbus/char" failed: No space 
left on device (28)
rsync: mkstemp 
"/mnt/.software/kernel/linux-3.9-rc3/drivers/regulator/.aat2870-regulator.c.BGDwPN" 
failed: No space left on device (28)
*** Skipping any contents from this failed directory ***
.software/kernel/linux-3.9-rc3/drivers/scsi/
.software/kernel/linux-3.9-rc3/drivers/scsi/.3w-9xxx.ko.cmd
          208 100%    0.16kB/s    0:00:01 (xfer#21400, to-check=1407/53242)
.software/kernel/linux-3.9-rc3/drivers/scsi/.3w-9xxx.mod.o.cmd
        27987 100%   21.54kB/s    0:00:01 (xfer#21401, to-check=1406/53242)
.software/kernel/linux-3.9-rc3/drivers/scsi/.3w-9xxx.o.cmd
        43340 100%   32.63kB/s    0:00:01 (xfer#21402, to-check=1405/53242)
.software/kernel/linux-3.9-rc3/drivers/scsi/.3w-sas.ko.cmd
          204 100%   15.32kB/s    0:00:00 (xfer#21403, to-check=1404/53242)
.software/kernel/linux-3.9-rc3/drivers/scsi/.3w-sas.mod.o.cmd
        27975 100%    1.91MB/s    0:00:00 (xfer#21404, to-check=1403/53242)
.software/kernel/linux-3.9-rc3/drivers/scsi/.3w-sas.o.cmd
        43327 100%  983.99kB/s    0:00:00 (xfer#21405, to-check=1402/53242)
.software/kernel/linux-3.9-rc3/drivers/scsi/.3w-xxxx.ko.cmd
          208 100%    4.72kB/s    0:00:00 (xfer#21406, to-check=1401/53242)
.software/kernel/linux-3.9-rc3/drivers/scsi/.3w-xxxx.mod.o.cmd
        27987 100%  621.16kB/s    0:00:00 (xfer#21407, to-check=1400/53242)
.software/kernel/linux-3.9-rc3/drivers/scsi/.3w-xxxx.o.cmd
        43340 100%  742.53kB/s    0:00:00 (xfer#21408, to-check=1399/53242)

dmesg Output was pretty long so i posted to pastebin:
http://pastebin.com/raw.php?i=5kUS5MGA

Greets,
Stefan
