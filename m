Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from srv2.trombetti.net ([65.254.53.252]:3885 "EHLO
	srv2.trombetti.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbaJJLMi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 07:12:38 -0400
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: SASL)
	by srv2.trombetti.net (Postfix) with ESMTPSA id 9615F313AB
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 07:25:25 -0400 (EDT)
Message-ID: <5437BF23.6030000@shiftmail.org>
Date: Fri, 10 Oct 2014 13:12:35 +0200
From: Bob Marley <bobmarley@shiftmail.org>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: What is the vision for btrfs fs repair?
References: <54358C77.2070808@redhat.com>	<9251D9EB-5B12-4885-8C6B-FFA10B1CDA24@colorremedies.com>	<5437BAB2.1040605@shiftmail.org> <20141010165902.36262e8e@natsu>
In-Reply-To: <20141010165902.36262e8e@natsu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/10/2014 12:59, Roman Mamedov wrote:
> On Fri, 10 Oct 2014 12:53:38 +0200
> Bob Marley <bobmarley@shiftmail.org> wrote:
>
>> On 10/10/2014 03:58, Chris Murphy wrote:
>>>> * mount -o recovery
>>>> 	"Enable autorecovery attempts if a bad tree root is found at mount time."
>>> I'm confused why it's not the default yet. Maybe it's continuing to evolve at a pace that suggests something could sneak in that makes things worse? It is almost an oxymoron in that I'm manually enabling an autorecovery
>>>
>>> If true, maybe the closest indication we'd get of btrfs stablity is the default enabling of autorecovery.
>> No way!
>> I wouldn't want a default like that.
>>
>> If you think at distributed transactions: suppose a sync was issued on
>> both sides of a distributed transaction, then power was lost on one
>> side
> What distributed transactions? Btrfs is not a clustered filesystem[1], it does
> not support and likely will never support being mounted from multiple hosts at
> the same time.
>
> [1]http://en.wikipedia.org/wiki/Clustered_file_system
>

This is not the only way to do a distributed transaction.
Databases can be hosted on the filesystem, and those can do distributed 
transations.
Think of two bank accounts, one on btrfs fs1 here, and another bank 
account on database on a whatever filesystem in another country. You 
want to debit one account and credit the other one: the filesystems at 
the two sides *must not rollback their state* !! (especially not 
transparently without human intervention)

