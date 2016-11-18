Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:55884 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932332AbcKRQSH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 11:18:07 -0500
Subject: Re: Btrfs Heatmap - v2 - block group internals!
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <e69c35cc-d693-da18-5aba-e78ae42262cd@mendix.com>
 <7a297aaa-f273-fb15-8e97-8c781e25f06a@mendix.com>
 <fda30533-068c-69d8-064f-fbbec06a6d22@cn.fujitsu.com>
 <68eecdb7-90e4-a5ba-ca63-f714faf88ede@mendix.com>
 <c067cd99-31ba-9e33-6da6-1d55c1a8c8f5@gmail.com>
 <02310b0f-5fed-746a-ca05-d655dce7d57a@cn.fujitsu.com>
 <9945f788-2516-007b-43ce-dabcff263cd8@mendix.com>
 <64e34b7e-9d34-8697-0d1d-5b5b2c9a903d@gmail.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <e29f274a-7b8b-c6c8-3ba8-20fe19759673@mendix.com>
Date: Fri, 18 Nov 2016 17:18:03 +0100
MIME-Version: 1.0
In-Reply-To: <64e34b7e-9d34-8697-0d1d-5b5b2c9a903d@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/18/2016 04:30 PM, Austin S. Hemmelgarn wrote:
> 
> Now, I personally have no issue with the Hilbert ordering, but if there
> were an option to use a linear ordering, I would almost certainly use
> that instead, simply because I could more easily explain the data to
> people.

It's in there, but hidden :)

--curve linear

-- 
Hans van Kranenburg
