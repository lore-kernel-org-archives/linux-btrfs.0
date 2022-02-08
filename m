Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3852FC433EF
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Feb 2022 19:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385817AbiBHTGt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Feb 2022 14:06:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352581AbiBHTGs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Feb 2022 14:06:48 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19A4C0613CB;
        Tue,  8 Feb 2022 11:06:47 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 85DA8210F5;
        Tue,  8 Feb 2022 19:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1644347206;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uuczzsLerYxf5+rv4LqJaLUqY8prQZza42JsJ9r52vw=;
        b=aSx5mvQqEJxFgLpdX14GPITrKNOUKdehmtwf/lK4cXBI0v8TKIXlJLz1Yw8LPPGqez/MZU
        5iZYaEVxHsz7fcZUJDAW0vZZDqWcRzlUjZPi6C7aaFUACoI4w87g5buWuE6AxhAS8sQoUS
        Zt9U1CaviNefBLTvd5gjvwlv1mUS7CQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1644347206;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uuczzsLerYxf5+rv4LqJaLUqY8prQZza42JsJ9r52vw=;
        b=KaSdzSjTi4kfq97LsEmnuANFm+twdm3rbN8Wt0Ll0wZfFJtOQJetofYIJG9PuIAyFHy49E
        V0GY3kgOtU5CyaAA==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 08A0CA3B88;
        Tue,  8 Feb 2022 19:06:41 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8528EDAB3F; Tue,  8 Feb 2022 20:03:01 +0100 (CET)
Date:   Tue, 8 Feb 2022 20:03:01 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Namhyung Kim <namhyung@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Byungchul Park <byungchul.park@lge.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Radoslaw Burny <rburny@google.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 06/12] btrfs: change lockdep class size check using
 ks->names
Message-ID: <20220208190301.GF12643@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Byungchul Park <byungchul.park@lge.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Radoslaw Burny <rburny@google.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20220208184208.79303-1-namhyung@kernel.org>
 <20220208184208.79303-7-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220208184208.79303-7-namhyung@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 08, 2022 at 10:42:02AM -0800, Namhyung Kim wrote:
> With upcoming lock tracepoints config, it'd allow some lockdep
> annotation code without enabling CONFIG_LOCKDEP actually.  In that
> config, size of the struct lock_class_key would be 0.
> 
> But it'd cause divide-by-zero in btrfs_set_buffer_lockdep_class() due
> to ARRAY_SIZE macro.  Let's change it to use ks->names[] instead.  It
> should have the same size as with ks->keys[].
> 
> Cc: Chris Mason <clm@fb.com>
> Cc: Josef Bacik <josef@toxicpanda.com>
> Cc: David Sterba <dsterba@suse.com>
> Cc: linux-btrfs@vger.kernel.org
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: David Sterba <dsterba@suse.com>
