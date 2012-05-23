Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.dcc.ufba.br ([200.128.57.5]:48368 "EHLO jordan.dcc.ufba.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab2EWQYd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 May 2012 12:24:33 -0400
Message-ID: <20120523132430.21094akr2yskzcqm@webmail.dcc.ufba.br>
Date: Wed, 23 May 2012 13:24:30 -0300
From: ROGERIO DE CARVALHO BASTOS <rogeriobastos@dcc.ufba.br>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Cant mount multi-subvolume via fstab
References: <20120523120002.79a23bed@hercules.fisnuc.intranet.ufba.br>
 <20120523153316.GB31037@carfax.org.uk>
In-Reply-To: <20120523153316.GB31037@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Hugo Mills <hugo@carfax.org.uk>:

> On Wed, May 23, 2012 at 12:00:02PM -0300, Rogerio Bastos wrote:
>> Hi,
>>
>> I'm trying mount many subvolume during boot via fstab:
>>
>> UUID=xxx /usr btrfs subvol=usr,ro,nodev 0 0
>> UUID=xxx /home btrfs subvol=home,nodev,nosuid 0 0
>> UUID=xxx /var btrfs subvol=var,nodev 0 0
>> UUID=xxx /var/tmp btrfs subvol=var-tmp,nodev,noexec,nosuid 0 0
>>
>> But only the first one is mounted. When try to mount the others
>> subvolumes, I get this error:
>>
>> mount: /dev/sda3 already mounted or /home busy
>> mount: according to mtab, /dev/sda3 is mounted on /usr
>> mount: /dev/sda3 already mounted or /var busy
>> mount: according to mtab, /dev/sda3 is mounted on /usr
>> mount: mount point /var/tmp does not exist
>>
>> I'm using linux kernel 3.3.6 and mount 2.20 in Debian 7.
>
>    How are your subvolumes arranged?
>
>    If you have:
>
> top-level            # default subvolume mounted as /
>         `--- home
>         `--- usr
>         `--- var
>                `--- tmp
>
> and you are mounting / first, then you don't need to mount the
> subvolumes, as they're already visible within /  I'm not quite sure
> what the consequences of mounting a subvolume directly onto itself as
> a mountpoint are -- but it may have this effect.
>
>    If you have:
>
> top-level
>         `--- root    # default subvolume mounted as /
>         `--- home
>         `--- usr
>
> then you should be able to (and have to) mount them separately.
>
>    Hugo.

I have two partitions:

/dev/sda1 (top-level)  # root filesystem


/dev/sda3 (top-level)
    `--- home
    `--- var
    `--- var-tmp
    `--- usr


The sda3's top-level isn't being mounted.

-- 

Rogerio de Carvalho Bastos

http://wiki.dcc.ufba.br/Main/RogerioBastos

