Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxsystems.it ([79.7.78.67]:52520 "EHLO
        mail.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941111AbcKPWYi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Nov 2016 17:24:38 -0500
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        James Pharaoh <james@wellbehavedsoftware.com>,
        Mark Fasheh <mfasheh@versity.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: Announcing btrfs-dedupe
Date: Wed, 16 Nov 2016 23:24:33 +0100
MIME-Version: 1.0
Message-ID: <138b6c00-fb34-492b-92ae-d13630e0bb04@linuxsystems.it>
In-Reply-To: <20161115175201.GL21290@hungrycats.org>
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
 <CAAXPY_LJshM+W+xinabu_-=-E6J8UBMRpy7VPLt8tNihpO68Lw@mail.gmail.com>
 <345b3aa4-6644-6730-09dd-549d320f58cb@wellbehavedsoftware.com>
 <20161114180714.GF21290@hungrycats.org>
 <a4e42724-d84a-e4f9-a3ea-d1fec31a5629@wellbehavedsoftware.com>
 <dfb1372d-8bff-93ff-1ba7-d636e6c7fe4d@gmail.com>
 <20161114195102.GI21290@hungrycats.org>
 <4389716b-8082-ef89-7efc-60c2ae6b7db6@gmail.com>
 <20161114211013.GJ21290@hungrycats.org>
 <0b8cd1f0-fca4-b7df-2f41-13c40aee493d@gmail.com>
 <20161115175201.GL21290@hungrycats.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On martedì 15 novembre 2016 18:52:01 CET, Zygo Blaxell wrote:
> Like I said, millions of extents per week...
>
> 64K is an enormous dedup block size, especially if it comes with a 64K
> alignment constraint as well.
>
> These are the top ten duplicate block sizes from a sample of 95251
> dedup ops on a medium-sized production server with 4TB of filesystem
> (about one machine-day of data):

Which software do you use to dedupe your data? I tried duperemove but it 
gets killed by the OOM killer because it triggers some kind of memory leak: 
https://github.com/markfasheh/duperemove/issues/163

Niccolò Belli
