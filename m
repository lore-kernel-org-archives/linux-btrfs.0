Return-Path: <SRS0=1olR=OW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D9FC65BAE
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 18:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77AC52086D
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 18:59:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 77AC52086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbeLMS7Z (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Dec 2018 13:59:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:37942 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726453AbeLMS7Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Dec 2018 13:59:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3BC8FAE6E
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Dec 2018 18:59:23 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 84D2EDA7EE; Thu, 13 Dec 2018 19:59:01 +0100 (CET)
Date:   Thu, 13 Dec 2018 19:59:01 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 04/13] btrfs-progs: Fix Wempty-body warning
Message-ID: <20181213185901.GL23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181205064018.27755-1-wqu@suse.com>
 <20181205064018.27755-5-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181205064018.27755-5-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 05, 2018 at 02:40:09PM +0800, Qu Wenruo wrote:
> messages.h:49:24: warning: suggest braces around empty body in an 'if' statement [-Wempty-body]
>     PRINT_TRACE_ON_ERROR;    \
> 
> Just extra braces would solve the problem.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  messages.h | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/messages.h b/messages.h
> index ec7d93381a36..16f650d19a4b 100644
> --- a/messages.h
> +++ b/messages.h
> @@ -45,13 +45,16 @@
>  
>  #define error_on(cond, fmt, ...)					\
>  	do {								\
> -		if ((cond))						\
> +		if ((cond)) {						\
>  			PRINT_TRACE_ON_ERROR;				\

I think the definition of PRINT_TRACE_ON_ERROR should be fixed to always
emit a statement, a "do { } while (0)" in the other case. Otherwise it's
"don't forget to enclose in { } if used", the proposed change looks
lightly safer to me. I'll update the patch, no need to resend, please
let me know if it's ok for you.
