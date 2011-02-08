From: Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: Re: mkfs.btrfs - error checking /dev/sda5 mount status
Date: Tue, 8 Feb 2011 21:26:49 +0000 (UTC)
Message-ID: <iiscep$udg$1@dough.gmane.org>
References: <iiqphe$217$1@dough.gmane.org> <4D51A0D9.9000701@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli, Tue, 08 Feb 2011 21:00:25 +0100:

> On 02/08/2011 07:57 AM, Lubos Kolouch wrote:
>> Hi,
>> 
>> I'm hitting this issue - sda5 is a normal device, nothing to do with
>> loop, encryption etc.
>> 
>> # mkfs.btrfs /dev/sda5
>> 
>> WARNING! - Btrfs v0.19-35-g1b444cd-dirty IS EXPERIMENTAL WARNING! - see
>> http://btrfs.wiki.kernel.org before using
>> 
>> error checking /dev/sda5 mount status
>> 
>> Is there something I can do to resolve this?
> 
> Some months ago I posted a patch [*] which allows to create a filesystem
> even if an integrity tests fail.
> Anyway it would be interesting understand why mkfs.btrfs fails. It is
> possible to have a strace of the command ?
> 

here ... http://paste.pocoo.org/show/334638/
but it is not in chroot, it is in "normal" system

Lubos

