Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A1B6C4332F
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Nov 2022 22:27:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiKYW07 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Nov 2022 17:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiKYW07 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Nov 2022 17:26:59 -0500
X-Greylist: delayed 78 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 25 Nov 2022 14:26:54 PST
Received: from ts201-smtpout75.ddc.teliasonera.net (ts201-smtpout75.ddc.teliasonera.net [81.236.60.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EDAB121273
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Nov 2022 14:26:54 -0800 (PST)
X-RG-Rigid: 63736B1100A214E7
X-Originating-IP: [212.181.211.57]
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedvgedrieehgdduiedvucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuvffgnffktefuhgdpggftfghnshhusghstghrihgsvgdpqfgfvfenuceurghilhhouhhtmecufedttdenucenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttdefjeenucfhrhhomhepvfhorhgsjhpnrhhnucflrghnshhsohhnuceothhorhgsjhhorhhnsehjrghnshhsohhnrdhtvggthheqnecuggftrfgrthhtvghrnhephfeuueejuedvgefhhfduheeiffetvdeihfekfeegtdeuleehveeiieefvdffvdelnecukfhppedvuddvrddukedurddvuddurdehjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhephhgvlhhopehgrghmmhgurghtrghnrdhhohhmvgdrlhgrnhdpihhnvghtpedvuddvrddukedurddvuddurdehjedpmhgrihhlfhhrohhmpehtohhrsghjohhrnhesjhgrnhhsshhonhdrthgvtghhpdhnsggprhgtphhtthhopeegpdhrtghpthhtoheprghhohhjjeelsehgmhgrihhlrdgtohhmpdhrtghpthhtoheplhhinhhugidqsghtrhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehquhifvghnrhhuohdrsghtrhhfshesghhmgidrtghomhdprhgtphhtthhopeifqhhusehsuhhsvgdrtghomh
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
Received: from gammdatan.home.lan (212.181.211.57) by ts201-smtpout75.ddc.teliasonera.net (5.8.716)
        id 63736B1100A214E7; Fri, 25 Nov 2022 23:25:32 +0100
Received: from [192.168.9.3] ([192.168.9.3])
        by gammdatan.home.lan (8.17.1/8.17.1) with ESMTP id 2APMPWYS1009272;
        Fri, 25 Nov 2022 23:25:32 +0100
Message-ID: <aa599399-527d-8fc4-5fd4-dd31ae82d49e@jansson.tech>
Date:   Fri, 25 Nov 2022 23:25:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: Speed up mount time?
To:     Joakim <ahoj79@gmail.com>, quwenruo.btrfs@gmx.com
Cc:     linux-btrfs@vger.kernel.org, wqu@suse.com
References: <e1eac218-bc97-0f62-4be8-b81c37b76296@gmx.com>
 <20221125092255.316-1-ahoj79@gmail.com>
Content-Language: en-US
From:   =?UTF-8?Q?Torbj=c3=b6rn_Jansson?= <torbjorn@jansson.tech>
In-Reply-To: <20221125092255.316-1-ahoj79@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2022-11-25 10:22, Joakim wrote:
> Alright, thanks for clarification.
> This machine has Oracle Linux, so i guess there will be som waiting.
> 
> //Joakim

Quoting the original mail when replying helps a lot to understand what you are 
actually replying to.

