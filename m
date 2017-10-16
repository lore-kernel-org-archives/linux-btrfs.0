Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:37082 "EHLO
        zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752358AbdJPP7R (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 11:59:17 -0400
Received: from black.home.cobb.me.uk (unknown [192.168.0.205])
        by zaphod.cobb.me.uk (Postfix) with ESMTP id 7C0859BAA0
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Oct 2017 16:59:15 +0100 (BST)
Received: from [192.168.0.211] (novatech.home.cobb.me.uk [192.168.0.211])
        by black.home.cobb.me.uk (Postfix) with ESMTPS id 30ADC5FBB1
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Oct 2017 16:59:15 +0100 (BST)
Subject: Re: Why isnt NOCOW attributes propogated on snapshot transfers?
To: linux-btrfs@vger.kernel.org
References: <CAN4oSBcZmqh+iK7Qyd4VBcOhQDfZVAu2B7_1pL60UKCb_oX3zg@mail.gmail.com>
 <20171016132826.GH3521@twin.jikos.cz>
From: Graham Cobb <g.btrfs@cobb.uk.net>
Message-ID: <a3f7cc05-d6c0-f6c9-f93d-616c386db691@cobb.uk.net>
Date: Mon, 16 Oct 2017 16:59:14 +0100
MIME-Version: 1.0
In-Reply-To: <20171016132826.GH3521@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 16/10/17 14:28, David Sterba wrote:
> On Sun, Oct 15, 2017 at 04:19:23AM +0300, Cerem Cem ASLAN wrote:
>> `btrfs send | btrfs receive` removes NOCOW attributes. Is it a bug or
>> a feature? If it's a feature, how can we keep these attributes if we
>> need to?
> 
> This is a known defficiency of send protocol v1. And there are more,
> listed on
> https://btrfs.wiki.kernel.org/index.php/Design_notes_on_Send/Receive#Send_stream_v2_draft

It is not mentioned on the list (and I haven't tested to find out)...
but if xattr are supported in the V1 protocol, any chance of `send`
converting these file flags to xattr, and `receive` converting back? No
need for a protocol bump and would even preserve the information
(although not the effect) in the case of an old receiver.
