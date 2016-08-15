Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:37833 "EHLO
	mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbcHOLdk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Aug 2016 07:33:40 -0400
Received: by mail-it0-f50.google.com with SMTP id f6so40173350ith.0
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Aug 2016 04:33:40 -0700 (PDT)
Received: from [191.9.212.201] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id c40sm9646241iod.6.2016.08.15.04.33.37
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Aug 2016 04:33:38 -0700 (PDT)
Subject: Re: checksum error in metadata node - best way to move root fs to new
 drive?
To: linux-btrfs@vger.kernel.org
References: <CAGdWbB5LX5KprZYQeUiyedoaN=ggPKesw9iXqFBWTuRKFn9cZQ@mail.gmail.com>
 <35417d9d-c3e4-6a3a-50e0-bdd91bf39f80@gmail.com>
 <pan$c5e52$548e4e68$60e28d88$8f006dcd@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <417d2c08-988d-c674-889a-ab9b564f7a3e@gmail.com>
Date: Mon, 15 Aug 2016 07:33:16 -0400
MIME-Version: 1.0
In-Reply-To: <pan$c5e52$548e4e68$60e28d88$8f006dcd@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-08-12 11:06, Duncan wrote:
> Austin S. Hemmelgarn posted on Fri, 12 Aug 2016 08:04:42 -0400 as
> excerpted:
>
>> On a file server?  No, I'd ensure proper physical security is
>> established and make sure it's properly secured against network based
>> attacks and then not worry about it.  Unless you have things you want to
>> hide from law enforcement or your government (which may or may not be
>> legal where you live) or can reasonably expect someone to steal the
>> system, you almost certainly don't actually need whole disk encryption.
>> There are two specific exceptions to this though:
>> 1. If your employer requires encryption on this system, that's their
>> call.
>> 2. Encrypted swap is a good thing regardless, because it prevents
>> security credentials from accidentally being written unencrypted to
>> persistent storage.
>
> In the US, medical records are pretty well protected under penalty of law
> (HIPPA, IIRC?).  Anyone storing medical records here would do well to
> have full filesystem encryption for that reason.
>
> Of course financial records are sensitive as well, or even just forum
> login information, and then there's the various industrial spies from
> various countries (China being the one most frequently named) that would
> pay good money for unencrypted devices from the right sources.
>
Medical and even financial records really fall under my first exception, 
but it's still no substitute for proper physical security.  As far as 
user account information, that depends on what your legal or PR 
department promised, but in many cases there, there's minimal 
improvement in security when using full disk encryption in place of just 
encrypting the database file used to store the information.

In either case though, it's still a better investment in terms of both 
time and money to properly secure the network and physical access to the 
hardware.  All that disk encryption protects is data at rest, and for a 
_server_ system, the data is almost always online, and therefore lack of 
protection of the system as a whole is usually more of a security issue 
in general than lack of protection for a single disk that's powered off.
