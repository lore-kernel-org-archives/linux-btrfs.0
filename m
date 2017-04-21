Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:47946 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1036606AbdDUKbV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Apr 2017 06:31:21 -0400
Received: from [IPv6:2001:828:13c8:10b::c] (blackbox.bofh.hq.mendix.net [IPv6:2001:828:13c8:10b::c])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id 5747B6003D
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Apr 2017 12:31:20 +0200 (CEST)
Subject: Re: Experiences with metadata balance/convert
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <78d61749-ec9c-1cc3-196f-5330489e2b3e@mendix.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <f0c293aa-06b9-3478-2d72-905797708ec9@mendix.com>
Date: Fri, 21 Apr 2017 12:31:20 +0200
MIME-Version: 1.0
In-Reply-To: <78d61749-ec9c-1cc3-196f-5330489e2b3e@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Doh,

On 04/21/2017 12:26 PM, Hans van Kranenburg wrote:
> [...]
> 
> == Thinking out of the box ==
> 
> Technically, converting from DUP to single could also mean:
> * Flipping one bit in the block group type flags to 0 for each block
> group item
> * Flipping one bit in the chunk type flags and removing 1 stripe struct
> for each metadata chunk item
> * Removing the

Removing the dev extent objects for all removed stripes from the dev tree.

> * Anything else?
> 
> How feasible would it be to write btrfs-progs style conversion to do this?


-- 
Hans van Kranenburg
