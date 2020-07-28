Return-Path: <SRS0=QcMt=BH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED8E2C433E1
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 Jul 2020 11:39:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEA332074F
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 Jul 2020 11:39:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbgG1LjJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 28 Jul 2020 07:39:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:53884 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729120AbgG1LjI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Jul 2020 07:39:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5363CB611;
        Tue, 28 Jul 2020 11:39:18 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 437CFDA701; Tue, 28 Jul 2020 13:38:38 +0200 (CEST)
Date:   Tue, 28 Jul 2020 13:38:37 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2] btrfs-progs: Add basic .editorconfig
Message-ID: <20200728113837.GR3703@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Daniel Xu <dxu@dxuuu.xyz>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20200728015715.142747-1-dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728015715.142747-1-dxu@dxuuu.xyz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jul 27, 2020 at 06:57:15PM -0700, Daniel Xu wrote:
> Not all contributors work on projects that use linux kernel coding
> style. This commit adds a basic editorconfig [0] to assist contributors
> with managing configuration.
> 
> [0]: https://editorconfig.org/
> 
> Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> ---
> Changes from V1:
> * use tabs instead of spaces
> 
>  .editorconfig | 10 ++++++++++
>  .gitignore    |  1 +
>  2 files changed, 11 insertions(+)
>  create mode 100644 .editorconfig
> 
> diff --git a/.editorconfig b/.editorconfig
> new file mode 100644
> index 00000000..7e15c503
> --- /dev/null
> +++ b/.editorconfig
> @@ -0,0 +1,10 @@
> +[*]
> +end_of_line = lf
> +insert_final_newline = true
> +trim_trailing_whitespace = true

Does this setting apply on lines that get changed or does it affect the
whole file? If it's just for the lines, then it's what we want.
