Return-Path: <SRS0=M5aM=SM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48AD9C10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 12:06:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2029420818
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 12:06:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729844AbfDJMGO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Apr 2019 08:06:14 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:59213 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728687AbfDJMGN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Apr 2019 08:06:13 -0400
Received: from [147.83.201.128] (helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hEBzB-0006mW-0N; Wed, 10 Apr 2019 14:05:49 +0200
Date:   Wed, 10 Apr 2019 14:05:17 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Johannes Thumshirn <jthumshirn@suse.de>
cc:     LKML <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexander Potapenko <glider@google.com>,
        David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC patch 29/41] btrfs: ref-verify: Simplify stack trace
 retrieval
In-Reply-To: <20190410113115.GB4610@linux-x5ow.site>
Message-ID: <alpine.DEB.2.21.1904101404280.3479@nanos.tec.linutronix.de>
References: <20190410102754.387743324@linutronix.de> <20190410103646.221275815@linutronix.de> <20190410113115.GB4610@linux-x5ow.site>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, 10 Apr 2019, Johannes Thumshirn wrote:

> On Wed, Apr 10, 2019 at 12:28:23PM +0200, Thomas Gleixner wrote:
> > Replace the indirection through struct stack_trace with an invocation of
> > the storage array based interface.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: David Sterba <dsterba@suse.com>
> > Cc: Chris Mason <clm@fb.com>
> > Cc: Josef Bacik <josef@toxicpanda.com>
> > Cc: linux-btrfs@vger.kernel.org
> > ---
> >  fs/btrfs/ref-verify.c |   15 ++-------------
> >  1 file changed, 2 insertions(+), 13 deletions(-)
> > 
> > --- a/fs/btrfs/ref-verify.c
> > +++ b/fs/btrfs/ref-verify.c
> > @@ -205,28 +205,17 @@ static struct root_entry *lookup_root_en
> >  #ifdef CONFIG_STACKTRACE
> >  static void __save_stack_trace(struct ref_action *ra)
> >  {
> > -	struct stack_trace stack_trace;
> > -
> > -	stack_trace.max_entries = MAX_TRACE;
> > -	stack_trace.nr_entries = 0;
> > -	stack_trace.entries = ra->trace;
> > -	stack_trace.skip = 2;
> > -	save_stack_trace(&stack_trace);
> > -	ra->trace_len = stack_trace.nr_entries;
> > +	ra->trace_len = stack_trace_save(ra->trace, MAX_TRACE, 2);
> 
> 
> Stupid question: why are you passing a '2' for 'skipnr' and in
> stack_trace_save() from your series you set stack_trace::skip as skipnr + 1. 
> 
> Wouldn't this result in a stack_trace::skip = 3? Or is it the number of
> functions to be skipped and you don't want to have stack_trace_save() saved as
> well? 

Correct. The extra call will shift the skipped one up, so I compensate for that.

Thanks,

	tglx
