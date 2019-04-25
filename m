Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16AABC282E1
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 10:09:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBFE8214AE
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 10:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556186984;
	bh=LFYOnrzOnqHgCaRL1dV3rewYVMdVsYB0QjuTPuTNuS8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=TN4LjRpHKaxvAJYx20azDoGG6ri68XoqGe6ieZS1yImh0vY9Jjg78zqSWk4eZD9Cj
	 lMsL92d/ixxI+ZnjVXMqxpcW4PGZuxGEmY3f92fBmfKoA44jL+PO0pZzWHB4ClIbLO
	 uNrNTrjH9b70nSGdLlUFw2AP6WxsM+DkPC+aGjn8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbfDYKJk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 06:09:40 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:39793 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbfDYKJj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 06:09:39 -0400
Received: by mail-wm1-f53.google.com with SMTP id n25so9694421wmk.4;
        Thu, 25 Apr 2019 03:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qDXe8aInWx7rrUFbUzdCjPGqVvpdtP3z9EWwVfzbZc0=;
        b=kAxXHkZYy9zXKuU1mD/GV24mrHOTRf2dSE1dytqyDTE9UDI6Qs03UeV4nB5Yquf+nl
         1tep2U7T3Sryt2ngffH0HbGnWoldhLQYMgCmjjSkzwRogMPhe3prjnuLu6GRBIQdgUmP
         FO9A7NNqPP+fSPIriO0PBVmQlihNr+lRUE9kN3TizxGphIMjD0dAZh3pX8+TVTBIlEGM
         NvtAJ9V68fpOVi2Lsx5HMiib5OaOfiymoKlY6eqWti6BEHTZMF6SWGNJ9IBt5/IKPWow
         QfTd69DVj5A06mVnuB2nERuOjY3Jq4M3TbOja1rBzuWUVL+Z+FGC8ZLEkNP4i5JfSmzV
         aAvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=qDXe8aInWx7rrUFbUzdCjPGqVvpdtP3z9EWwVfzbZc0=;
        b=intRd2J8Rd0dT9xsoF/UrTxTB+DwQvwijrTcwdCOnUy3+pxgVtf6u2pkngq7j/5EP1
         VQvqpAZHXOlO8cyU6wsxniLgvqNcnIljtYreVLRMPkS9gGlAllJHMx3KDlwnIuebevbL
         zpKbbzeMHqTJsNlhHPCl95sEUtcUA9iFODFT2S1Cdrdv9HmiEAoBlvCJZU3nazjRqcaC
         NUwl7/I4isC3YVlPgvfdrJ1quJwiec5uqDVR6dv0sxnscolyhj4ejwwNxAg25c9as23I
         GgObq6/XyWh6inrijEOmJc5EpgBnAMsf7pn56urzLWd3QnuZQwrRqHgGqbPHtdDhW46g
         b8PQ==
X-Gm-Message-State: APjAAAUcCTJpOO4mfQ+4Vu3bUXTn3OUpCZNSq9InHolFd/wnJx3IfESk
        U0PiY3GbouFBdTxmHzoDOMY=
X-Google-Smtp-Source: APXvYqx2GAh1uv+m48koOKK3YSqfB/7bnkVhISaxrxFGwOyRBo5NQ9XpO4CFxCAJqjHa83cweimVmQ==
X-Received: by 2002:a1c:6c04:: with SMTP id h4mr2890302wmc.135.1556186977884;
        Thu, 25 Apr 2019 03:09:37 -0700 (PDT)
Received: from gmail.com (2E8B0CD5.catv.pool.telekom.hu. [46.139.12.213])
        by smtp.gmail.com with ESMTPSA id c2sm19739225wrr.13.2019.04.25.03.09.35
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Apr 2019 03:09:37 -0700 (PDT)
Date:   Thu, 25 Apr 2019 12:09:33 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexander Potapenko <glider@google.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        kasan-dev@googlegroups.com,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        iommu@lists.linux-foundation.org,
        Robin Murphy <robin.murphy@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, dm-devel@redhat.com,
        Mike Snitzer <snitzer@redhat.com>,
        Alasdair Kergon <agk@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Miroslav Benes <mbenes@suse.cz>, linux-arch@vger.kernel.org
Subject: Re: [patch V3 00/29] stacktrace: Consolidate stack trace usage
Message-ID: <20190425100933.GB8387@gmail.com>
References: <20190425094453.875139013@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190425094453.875139013@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> -	if (unlikely(!ret))
> +	if (unlikely(!ret)) {
> +		if (!trace->nr_entries) {
> +			/*
> +			 * If save_trace fails here, the printing might
> +			 * trigger a WARN but because of the !nr_entries it
> +			 * should not do bad things.
> +			 */
> +			save_trace(trace);
> +		}
>  		return print_circular_bug(&this, target_entry, next, prev);
> +	}
>  	else if (unlikely(ret < 0))
>  		return print_bfs_bug(ret);

Just a minor style nit: the 'else' should probably on the same line as 
the '}' it belongs to, to make it really obvious that the 'if' has an 
'else' branch?

At that point the condition should probably also use balanced curly 
braces.

Interdiff looks good otherwise.

Thanks,

	Ingo
