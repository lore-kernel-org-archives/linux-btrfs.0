Return-Path: <SRS0=M5aM=SM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77CE4C10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 11:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CE2F2083E
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 11:31:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731039AbfDJLbU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Apr 2019 07:31:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:34660 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727206AbfDJLbU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Apr 2019 07:31:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 08A24AF1A;
        Wed, 10 Apr 2019 11:31:18 +0000 (UTC)
Date:   Wed, 10 Apr 2019 13:31:15 +0200
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexander Potapenko <glider@google.com>,
        David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC patch 29/41] btrfs: ref-verify: Simplify stack trace
 retrieval
Message-ID: <20190410113115.GB4610@linux-x5ow.site>
References: <20190410102754.387743324@linutronix.de>
 <20190410103646.221275815@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190410103646.221275815@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 10, 2019 at 12:28:23PM +0200, Thomas Gleixner wrote:
> Replace the indirection through struct stack_trace with an invocation of
> the storage array based interface.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: David Sterba <dsterba@suse.com>
> Cc: Chris Mason <clm@fb.com>
> Cc: Josef Bacik <josef@toxicpanda.com>
> Cc: linux-btrfs@vger.kernel.org
> ---
>  fs/btrfs/ref-verify.c |   15 ++-------------
>  1 file changed, 2 insertions(+), 13 deletions(-)
> 
> --- a/fs/btrfs/ref-verify.c
> +++ b/fs/btrfs/ref-verify.c
> @@ -205,28 +205,17 @@ static struct root_entry *lookup_root_en
>  #ifdef CONFIG_STACKTRACE
>  static void __save_stack_trace(struct ref_action *ra)
>  {
> -	struct stack_trace stack_trace;
> -
> -	stack_trace.max_entries = MAX_TRACE;
> -	stack_trace.nr_entries = 0;
> -	stack_trace.entries = ra->trace;
> -	stack_trace.skip = 2;
> -	save_stack_trace(&stack_trace);
> -	ra->trace_len = stack_trace.nr_entries;
> +	ra->trace_len = stack_trace_save(ra->trace, MAX_TRACE, 2);


Stupid question: why are you passing a '2' for 'skipnr' and in
stack_trace_save() from your series you set stack_trace::skip as skipnr + 1. 

Wouldn't this result in a stack_trace::skip = 3? Or is it the number of
functions to be skipped and you don't want to have stack_trace_save() saved as
well? 

Thanks,
	Johannes
-- 
Johannes Thumshirn                            SUSE Labs Filesystems
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
