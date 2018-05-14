Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:36389 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752060AbeENLoI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 07:44:08 -0400
Received: by mail-io0-f181.google.com with SMTP id d73-v6so14810671iog.3
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 04:44:07 -0700 (PDT)
Subject: Re: Btrfs installation advices
To: faurepierr@gmail.com, linux-btrfs@vger.kernel.org
References: <a064411e-dcec-ecc8-98b9-98cb86284f1e@gmail.com>
 <63a6c2b4-79ab-18bd-2e24-6acf10b2fd63@lug-balista.de>
 <7d680d1c-60af-0d4e-1a91-c2814b1aa26d@gmail.com>
 <44a24671-887d-f927-c88e-3fc4246c5dac@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <2a810258-99f6-9be1-d9a1-8bfa96b748a8@gmail.com>
Date: Mon, 14 May 2018 07:44:04 -0400
MIME-Version: 1.0
In-Reply-To: <44a24671-887d-f927-c88e-3fc4246c5dac@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-05-12 21:58, faurepierr@gmail.com wrote:
> Thanks you two very much for your answers.
> 
> So if I sum up correctly, I could:
> 
> 1- use Self-Encrypting Drive (SED), since my drive is a Samsung NVMe 960 
> EVO, which is supposed to support SED according to 
> http://www.samsung.com/semiconductor/minisite/ssd/support/faqs-nvmessd:
> "*Do Samsung NVMe M.2 SSDs have hardware encryption?*
> Samsung NVMe SSDs provide internal hardware encryption of all data 
> stored on the SSD, including the operating system. Data is decrypted 
> through a pre-boot authentication process.
> Because all user data is encrypted, private information is protected 
> against loss or theft.
> Encryption is done by hardware, which provides a safer environment 
> without sacrificing performance.
> 
> The encryption methods provided by each Samsung NVMe SSD are: AES 
> (Advanced Encryption Standard, Class0 SED) TCG/OPAL, and eDrive
> 
> Please note that you cannot use more than one encryption method 
> simultaneously.
> 
> 
> *Do Samsung NVMe M.2 SSDs support TCG Opal?*
> TCG Opal is supported by Samsung NVMe SSDs (960EVO / PRO and newer). It 
> is an authentication method that employs the protocol specified by the 
> Trusted Computing Group (TCG) meaning that you will need to install TCG 
> software supplied by a TCG OPAL software development company.
> 
> User authentication is done by pre-boot authentication provided by the 
> software. For more detailed information and instructions, please contact 
> a TCG software company. In addition, TCG/opal can only be enabled / 
> disabled by using special security software. "
> 
> For the moment, I don't know how to use that self-encryption from linux. 
> Could you please give me some tips or links about how you did?
> 
> 2- now that the full drive is self-encrypted, I can build manually the 
> three partitions from a live system: boot with ext(2,3,4), swap with 
> swap, and root with btrfs
> 
> 3- and finally install debian sid in the dedicaced partitions.
> 
> Am I right? :)
Yes, that approach will work, assuming you trust Samsung (since they're 
the ones who wrote the code responsible for the encryption, and you 
can't inspect that code yourself).
> 
> 
> Le 08/05/2018 à 13:32, Austin S. Hemmelgarn a écrit :
>> On 2018-05-08 03:50, Rolf Wald wrote:
>>> Hello,
>>>
>>> some hints inside
>>>
>>> Am 08.05.2018 um 02:22 schrieb faurepierr@gmail.com:
>>>> Hi,
>>>>
>>>> I'm curious about btrfs, and maybe considering it for my new laptop
>>>> installation (a Lenovo T470).
>>>> I was going to install my usual lvm+ext4+full disk encryption setup, 
>>>> but
>>>> thought I should maybe give a try to btrfs.
>>>>
>>>>
>>>> Is it possible to meet all these criteria?
>>>> - operating system: debian sid
>>>> - file system: btrfs
>>>> - disk encryption (or at least of sensitives partitions)
>>>> - hibernation feature (which implies a swap partition or file, and I've
>>>> read btrfs is not a big fan of the latter)
>>>
>>> A swap partition is not possible inside or with btrfs alone.
>>>
>>> You can choose btrfs filesystem out of the box in debian install, but 
>>> that would mean full-disk-encryption with lvm and btrfs. The extra 
>>> layer lvm doesn't hurt, but you have two layers with many functions 
>>> double, e.g. snapshotting, resize.
>> Um, this isn't really as much of an issue as you might think.  LVM has 
>> near zero overhead unless you're actually doing any of that stuff (as 
>> long as the LV is just a simple linear mapping, it has less than 1% 
>> more overhead than just using partitions).  The only real caveat here 
>> is to make _ABSOLUTELY CERTAIN_ that you _DO NOT_ make LVM snapshots 
>> of _ANY_ BTRFS volumes.  Doing so is a recipe for disaster, and will 
>> likely eat at least your data, and possibly your children.
>>
>> The bigger issue is that dm-crypt generally slows down device access, 
>> which BTRFS is very sensitive to.  Using BTRFS with FDE works, but 
>> it's slow, so I would only suggest doing it with an SSD (and if you're 
>> using an SSD, you may be better off getting a TCG Opal compliant 
>> self-encrypting drive and just using the self-encryption functionality 
>> instead of FDE).
>>>
>>>>
>>>> If yes, how would you suggest me to achieve it?
>>>
>>> Yes, there is a solution, and it works for me now several years.
>>> You need to build three partitions, e.g. named boot, swap, root. The 
>>> sizes choose to your need. the boot partition remains unencrypted, 
>>> but the other two partitions are encrypted with cryptsetup (luks) 
>>> separately. Normally there are two passphrases to type in (and to 
>>> remember), but there is an option in the cryptsetup scripts 
>>> (/lib/cryptsetup/scripts) decrypt_derived, which could take the key 
>>> from the root partition to decrypt the swap partition also. The 
>>> filesystems then on the partitions are boot with ext(2,3,4), swap 
>>> with swap and root with btrfs.
>>> This configuration is not reachable with a standard debian 
>>> installation. Debian always choose lvm if you want full encryption. 
>>> You have to do the first steps manually: make partitions, 
>>> cryptsetup(luks) for the partitions swap and root, and open the 
>>> encrypted partitions manually. After that you can install your OS. 
>>> The manual steps you have to make from a working distro, e.g. live 
>>> system (disk or stick) with a recent kernel and recent btrfs-progs 
>>> (debian sid is ok for this).
>>> After the install of the OS you have to made the changes for a 
>>> successful (re)boot manually. Please read the advices you can find in 
>>> the net. There are some nice articles.
>>>
>>>>
>>>> Thanks for your kind help.
>>>
>>
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

