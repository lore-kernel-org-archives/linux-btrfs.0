Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:33286 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbbEZSSl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 14:18:41 -0400
Received: by igbpi8 with SMTP id pi8so66777428igb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2015 11:18:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150526180820.GG16826@carfax.org.uk>
References: <20150526173634.GU11340@wantstofly.org>
	<20150526180820.GG16826@carfax.org.uk>
Date: Tue, 26 May 2015 12:18:40 -0600
Message-ID: <CAJCQCtQsCU9OhSPRjqTS30i8KeC-_aa9SG+qmViA_q5po00QrQ@mail.gmail.com>
Subject: Re: intermittent -ENOSPC errors on btrfs filesystem with 170G free
From: Chris Murphy <lists@colorremedies.com>
To: Hugo Mills <hugo@carfax.org.uk>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Oh yeah easy to miss, but obvious once pointed out:

> Data, single: total=227.94GiB, used=58.16GiB

I thought we had automatic deallocation of unused chunks but I guess
it hasn't landed yet.


Chris Murphy
