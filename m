Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2125CC677FC
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 17:22:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEBF22087D
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 17:22:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BEBF22087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=net-space.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731109AbeJLAut (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 20:50:49 -0400
Received: from dibed.net-space.pl ([84.10.22.86]:55257 "EHLO
        dibed.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727384AbeJLAut (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 20:50:49 -0400
Received: (from localhost user: 'dkiper' uid#4000 fake: STDIN
        (dkiper@dibed.net-space.pl)) by router-fw-old.i.net-space.pl
        id S1869268AbeJKRWT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 19:22:19 +0200
Date:   Thu, 11 Oct 2018 19:22:19 +0200
From:   Daniel Kiper <dkiper@net-space.pl>
To:     Nick Terrell <terrelln@fb.com>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        "grub-devel@gnu.org" <grub-devel@gnu.org>,
        Daniel Kiper <dkiper@net-space.pl>,
        Kernel Team <Kernel-team@fb.com>,
        David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] btrfs: Add zstd support to grub btrfs
Message-ID: <20181011172219.GD30679@router-fw-old.i.net-space.pl>
References: <20181009232137.1941290-1-terrelln@fb.com> <c00853f9-bc05-fe91-4e58-bf77f3da8583@molgen.mpg.de> <C0415AB7-FD1E-4026-8AEF-02B3F7FEABC5@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C0415AB7-FD1E-4026-8AEF-02B3F7FEABC5@fb.com>
User-Agent: Mutt/1.3.28i
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 10, 2018 at 08:28:27PM +0000, Nick Terrell wrote:
> > On Oct 10, 2018, at 12:34 AM, Paul Menzel <pmenzel@molgen.mpg.de> wrote:
> >
> > Sorry for being ignorant, but you explain, why the library needs to be imported and it is not enough to use that library as an external dependency?
> >
> > Importing the library means, it has to be maintained in the GRUB repository, which will result in some maintenance burden.
>
> I've imported zstd because thats the way the rest of the decompressors are imported.
>
> We could potentially use libzstd as an external dependency, since its only dependency is libc
> and GRUB provides the definitions of the libc functions that zstd needs to decompress
> (memcpy, and memmove). Theres some other stuff in the library that requires libc functionality
> that GRUB doesn't provide, but that isn't used during decompression. We strip those files
> out in the import.
>
> Let me know if you want me to switch to an external dependency.

I do not think it is possible. Or it can be at least difficult. Even if
it is possible it would require a major rework of GRUB build machine.
So, even if current solution is not perfect I would like to stick to it.
And zstd library integration is not very difficult. So, I do not think
it will add a lot of burden in the future.

Daniel
