Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:41975 "EHLO
        zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932492AbcIGQKV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Sep 2016 12:10:21 -0400
Received: from black.home.cobb.me.uk (unknown [192.168.0.205])
        by zaphod.cobb.me.uk (Postfix) with ESMTP id C89649B98A
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Sep 2016 17:10:16 +0100 (BST)
Received: from [192.168.0.211] (novatech.home.cobb.me.uk [192.168.0.211])
        by black.home.cobb.me.uk (Postfix) with ESMTPS id 88D875FB5B
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Sep 2016 17:10:16 +0100 (BST)
Subject: Re: Security implications of btrfs receive?
To: linux-btrfs@vger.kernel.org
References: <c04c596d-4cb9-ed98-513a-c550b1be18b2@cobb.uk.net>
 <2d59a472-4e74-d64c-27c4-28677d761316@gmail.com>
 <4afee621-0493-1ffc-31fe-fb81643f2374@cobb.uk.net>
 <4a00b682-c674-a46f-798e-d98b3e517f02@gmail.com>
 <f954e01c-3ccf-5b44-3fde-e627537f2af2@gmail.com>
From: Graham Cobb <g.btrfs@cobb.uk.net>
Message-ID: <f03940e1-cf4c-7354-97f4-8801ca4b4304@cobb.uk.net>
Date: Wed, 7 Sep 2016 17:10:15 +0100
MIME-Version: 1.0
In-Reply-To: <f954e01c-3ccf-5b44-3fde-e627537f2af2@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/09/16 16:20, Austin S. Hemmelgarn wrote:
> I should probably add to this that you shouldn't be accepting
> send/receive data streams from untrusted sources anyway.  While it
> probably won't crash your system, it's not intended for use as something
> like a network service.  If you're sending a subvolume over an untrusted
> network, you should be tunneling it through SSH or something similar,
> and then using that to provide source verification and data integrity
> guarantees, and if you can't trust the system's your running backups
> for, then you have bigger issues to deal with.

In my personal case I'm not talking about accepting streams from
untrusted sources (although that is also a perfectly reasonable question
to discuss).  My concern is if one of my (well managed and trusted but
never perfect) systems is hacked, can the intruder use that as an entry
to attack others of my systems?

In particular, I never trust my systems which live on the internet with
automated access to my personal systems (without a human providing
additional passwords/keys) although I do allow some automated accesses
the other way around.  I am trying to determine if sharing
btrfs-send-based backups would open a vulnerability.

There are articles on the web suggesting that centralised
btrfs-send-based backups are a good idea (using ssh access with separate
keys for each system which automatically invoke btrfs-receive into a
system-specific path).  My tests so far suggest that this may not be as
secure as the articles imply.

In any case, I think this is a topic worth investigating further, if any
graduate student is looking for a PhD topic!

