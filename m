Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:54996 "EHLO mail.bouton.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752398AbdENXIW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 May 2017 19:08:22 -0400
Subject: Re: balancing every night broke balancing so now I can't balance
 anymore?
To: Kai Krakow <hurikhan77@gmail.com>, linux-btrfs@vger.kernel.org
References: <20170513205431.lm6y5tcffr35gq4a@merlins.org>
 <95bffb8b-7e66-7d6b-2455-f7a025dbb96c@mendix.com>
 <20170514201508.bd3dshfymqt4swpb@merlins.org>
 <cf73557f-65e9-f9be-f8d7-4ed0de066eaf@bouton.name>
 <20170514233031.6f4724a1@jupiter.sol.kaishome.de>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <92786c59-7c78-e2ed-5631-4182a3b87fe2@bouton.name>
Date: Mon, 15 May 2017 01:08:20 +0200
MIME-Version: 1.0
In-Reply-To: <20170514233031.6f4724a1@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 14/05/2017 à 23:30, Kai Krakow a écrit :
> Am Sun, 14 May 2017 22:57:26 +0200
> schrieb Lionel Bouton <lionel-subscription@bouton.name>:
>
>> I've coded one Ruby script which tries to balance between the cost of
>> reallocating group and the need for it.[...]
>> Given its current size, I should probably push it on github...
> Yes, please... ;-)

Most of our BTRFS filesystems are used by Ceph OSD, so here it is :

https://github.com/jtek/ceph-utils/blob/master/btrfs-auto-rebalance.rb

Best regards,

Lionel
