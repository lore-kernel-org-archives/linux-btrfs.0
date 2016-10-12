Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:48591 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751969AbcJLX6L (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 19:58:11 -0400
Subject: Re: Incremental send robustness question
To: Sean Greenslade <sean@seangreenslade.com>
References: <20161012222955.GB2412@fox.home>
 <1bfe5018-3540-319d-813f-32a0571b57d1@mendix.com>
 <20161012234743.GA5000@fox.home>
Cc: Btrfs List <linux-btrfs@vger.kernel.org>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <0413c2c6-5574-24f8-cdbd-a5b7e7d1a19d@mendix.com>
Date: Thu, 13 Oct 2016 01:58:07 +0200
MIME-Version: 1.0
In-Reply-To: <20161012234743.GA5000@fox.home>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/13/2016 01:47 AM, Sean Greenslade wrote:
> On Thu, Oct 13, 2016 at 01:14:51AM +0200, Hans van Kranenburg wrote:
>> On 10/13/2016 12:29 AM, Sean Greenslade wrote:
>>> And while we're at it, what are the failure modes for incremental sends?
>>> Will it throw an error if the parents don't match, or will there just be
>>> silent failures?
>>
>> Create a list of possibilities, create some test filesystems, try it.
> 
> I may just do that, presuming I can find the spare time. Given that I'm
> building a backup solution around this tech, it would definitely bolster
> my confidence in it if I knew what its failure modes looked like.

Exactly :) Try to break it yourself before you have to start finding out
how things behave 3AM monday morning under pressure.

-- 
Hans van Kranenburg
