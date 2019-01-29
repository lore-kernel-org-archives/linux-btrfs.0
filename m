Return-Path: <SRS0=91MX=QF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C3BEC169C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 23:35:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD0292082C
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 23:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548804918;
	bh=jKx7n00oX0dR1L5E//HPsGQ9pEK63wyeN6DlIkcpK7Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=eExj0nxLSAZYHh4l89nYe1nKLDxvJWMLkKT6O41WYjrouyD9SO8f25MoocDnRDDcx
	 GQyToVW5Zzs5V1WaK+DAJkzVPIQqbMBBW9c93zZFfwu9pYOMCPjT/0godt2iTVZKCS
	 Ela85mm7KLCmpPkNMaZHRyrQAIFyCwmCrukDcnxY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729811AbfA2XfO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Jan 2019 18:35:14 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:42417 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbfA2XfN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Jan 2019 18:35:13 -0500
Received: by mail-yb1-f196.google.com with SMTP id l20so8792075ybl.9;
        Tue, 29 Jan 2019 15:35:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=DzsGR7EcseBbnz/4bU8r/qU0dlCHDSWhWNvmoLv1GsY=;
        b=ODDaZa94LyUfQdUYrEKv4M9L3sP0tDLiQ1Eu++759UALVfgvJajUceGdl4xasMDvGp
         iemMYDDnBnXA+s4bXwGxGA2/szrTRag5oWK/0JfKs4Q/MKbemXLKxeiYXibwMX1FCSLz
         9c0BbUndL1e+zGDOy9wnZjEhWQAZ+gHjh3/ThOYdUwcOAmHY36CVtnb7WYUh/nfSLqd3
         +4QmL0SCIqfgU7Ka8KGTD4pqDtSpQsw9Xegj3VEY0J2/0tuQRcJL5rJltGiT7/0/7ARL
         Ad0ebl2RQEyd8QUnx7UTd02nfNpOWBBUQtptWeLhI7BiX21dscmMvW3ZrGLv0qd/MOa6
         4jVA==
X-Gm-Message-State: AJcUukdQ/rTmjG+oiyxNwKtpmO/G+4DkSv3lRB8KokJIVX/x1iziOK+6
        kWVdWgwRJn7By8+gRwk9Ubc=
X-Google-Smtp-Source: ALg8bN7dEofRE+lGfVr/Liubr7JWreEdebHr26WcX7WN/U5ezdgzQtVUBQm6cEWuHJhCepvK1Whh0Q==
X-Received: by 2002:a25:d256:: with SMTP id j83mr18615117ybg.518.1548804912688;
        Tue, 29 Jan 2019 15:35:12 -0800 (PST)
Received: from dennisz-mbp.dhcp.thefacebook.com ([2620:10d:c091:200::5:f5f4])
        by smtp.gmail.com with ESMTPSA id q187sm13529304ywb.40.2019.01.29.15.35.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 15:35:11 -0800 (PST)
Date:   Tue, 29 Jan 2019 18:35:09 -0500
From:   Dennis Zhou <dennis@kernel.org>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/11] btrfs: move to fn pointers for get/put workspaces
Message-ID: <20190129233509.GC87266@dennisz-mbp.dhcp.thefacebook.com>
References: <20190128212437.11597-1-dennis@kernel.org>
 <20190128212437.11597-8-dennis@kernel.org>
 <6f9b4be7-0ce8-bd62-c90d-f3f537528b7a@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6f9b4be7-0ce8-bd62-c90d-f3f537528b7a@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Nikolay,

On Tue, Jan 29, 2019 at 10:22:34AM +0200, Nikolay Borisov wrote:
> 
> 
> On 28.01.19 г. 23:24 ч., Dennis Zhou wrote:
> > The previous patch added generic helpers for get_workspace() and
> > put_workspace(). Now, we can migrate ownership of the workspace_manager
> > to be in the compression type code as the compression code itself
> > doesn't care beyond being able to get a workspace. The init/cleanup
> > and get/put methods are abstracted so each compression algorithm can
> > decide how they want to manage their workspaces.
> > 
> > Signed-off-by: Dennis Zhou <dennis@kernel.org>

Thanks for reviewing my patches so promptly!

> 
> TBH I can't really see the value in this patch. IMO it doesn't make the
> code more readable, on the contrary, you create algorithm-specific
> wrappers over the generic function, where the sole specialization is in
> the arguments passed to the generic functions. You introduce 4 more
> function pointers and this affects performance negatively (albeit can't
> say to what extent) due to spectre mitigations (retpolines).
> 

I'll try and address the need for function pointers below, but of the 4,
only 2 are called often as 2 are for init and clenaup.

For the cost of function pointers, I tested with retpoline on, with zlib
both via function pointers and hard coded using the Silesia corpus test
in the cover letter. It didn't show up in perf and the runtimes were
very close to each other with the function pointers actually performing
marginally better. I imagine the actual compression is heavy enough that
it greatly outweighs the cost of a function pointer.

> I also read the follow up patches with the hopes of seeing how the code
> becomes cleaner to no avail. At this point I'm really not in favor of
> this particular patch.

So I guess to recap the whole idea. The original implementation forced
everyone to use workspaces_list. This is a generic implementation that
only allows the management of workspaces by a lru list.

Zstd compression levels introduces the requirement of being able to
distinguish workspaces. This is not possible with the original
workspaces_list implementation.  If I modify this, it becomes rather
cumbersome adding variables to the generic workspaces_list that will
only be used by a particular compression types. It also fractures the
code having find_workspace() and free_workspace() deal with changing
code paths based on the compression type.

I think a big strength of this series is that we no longer rely on using
paired arrays and passing around compression type. Once we are working
within a compression type, it is not possible to accidentally cross
boundaries due to an off by one error. Each compression type is siloed
with workspace management code being up to the compression type code and
not the core compression code.

This series works to migrate to a two-level API with get_workspace() and
put_workspace() being the interface that the core compression code
interacts with each compression type. The core compression code does not
and should not care beyond the fact that it is getting a workspace. So,
get_workspace() and put_workspace() deal with managing the workspaces
themselves. Underneath this is alloc_workspace() and free_workspace()
which deal only with creating and deleting a workspace.  I think the
division of labor here is neat and allows for code sharing.

Prior to this, no one really needed to do anything smarter with
workspace management and therefore could share a single implementation.
Now, zstd has to do something a little smarter based on the level
requested and has the ability to use higher level workspaces should they
be available. The division of the API let's zstd do just that. It hides
all of the manager complexity away from the core compression code.

I apologize if I'm only restating what I've already said. If the
reasoning is still unclear, I can try and be more specific to those
unaddressed areas.

Thanks,
Dennis
