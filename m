Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:39139 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759605Ab3B0STu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 13:19:50 -0500
Received: by mail-ee0-f53.google.com with SMTP id e53so788611eek.40
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 10:19:49 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Josef Bacik" <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Running Apache Derby on 3.8 and BTRFS cause kernel oops
References: <op.ws51z2nllpxuyk@kozzifx.lan>
 <20130227132513.GG19641@localhost.localdomain>
Date: Wed, 27 Feb 2013 19:19:46 +0100
MIME-Version: 1.0
From: =?utf-8?Q?Daniel_Koz=C3=A1k?= <kozzi11@gmail.com>
Message-ID: <op.ws6fu8smlpxuyk@kozzifx.lan>
In-Reply-To: <20130227132513.GG19641@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


[kozzi@KozziFX ~]$ mkdir derby
[kozzi@KozziFX ~]$ cd derby/
[kozzi@KozziFX derby]$ wget -c -q  
http://mirror.hosting90.cz/apache//db/derby/db-derby-10.9.1.0/db-derby-10.9.1.0-bin.zip
[kozzi@KozziFX derby]$ unzip -qq db-derby-10.9.1.0-bin.zip
[kozzi@KozziFX derby]$ cd db-derby-10.9.1.0-bin/
[kozzi@KozziFX db-derby-10.9.1.0-bin]$ DERBY_HOME=`pwd`
[kozzi@KozziFX db-derby-10.9.1.0-bin]$ java -jar  
$DERBY_HOME/lib/derbyrun.jar server start &
[kozzi@KozziFX db-derby-10.9.1.0-bin]$ java -jar  
$DERBY_HOME/lib/derbyrun.jar ij
verze ij 10.9
ij> CONNECT 'jdbc:derby://localhost:1527/seconddb;create=true';

BTW. after this I must restart my PC, and after restart, my system doesn't  
boot anymore :-) (some more btrfs oops).
So I must use btrfs check --repair /dev/sdaX.

Dne Wed, 27 Feb 2013 14:25:13 +0100 Josef Bacik <jbacik@fusionio.com>  
napsal(a):

> On Wed, Feb 27, 2013 at 06:20:16AM -0700, Daniel Kozák wrote:
>> Hello,
>>
>> On my both machine I have ArchLinux with recent kernel 3.8.0 btrfs as a
>> filesystem (with lzo compression). When I try use Apache derby (create
>> database), I almost every time get this kernel oops:
>
> Sweet somebody else is hitting this and I haven't been able to  
> reproduce.  Can
> you give me the exact commands you run so I can try and reproduce myself?
> Thanks,
>
> Josef


-- 
Vytvořeno poštovní aplikací Opery: http://www.opera.com/mail/
