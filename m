Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDCA7C433F5
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Feb 2022 14:29:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236034AbiBRO3j (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 18 Feb 2022 09:29:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233968AbiBRO3i (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Feb 2022 09:29:38 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6E54CD4E
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Feb 2022 06:29:20 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 673FB210DB;
        Fri, 18 Feb 2022 14:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1645194559;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u9tB9V1tVAPyqSbzKxn1E14NV4yrxhGx0sL81t92Kfs=;
        b=PSpoRfqhk4qQqtJk9immagcQKgGBZHoPmMFZ+EsleByHlkWJg8qOHN9Isc6Zl6eNafPRy3
        TtXSlqMkUnP2r1O3pw6YB7MQsk8i8fISsvsBP6dDzoRDL2sGkrzJl5WdFbSag/SoLKbR4P
        Wsizi7OXZW+wYF9Bzsrdbr+/vLYt4wc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1645194559;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u9tB9V1tVAPyqSbzKxn1E14NV4yrxhGx0sL81t92Kfs=;
        b=F3rj3Avh6gsXP2P7CUN+v48NK2ZydmzZFOjf3OEkeXY8JyhvZm1sv2VXqrxhaSShv4kKY8
        UqAFOZG17j84/RBg==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 60C13A3B85;
        Fri, 18 Feb 2022 14:29:19 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A9140DA829; Fri, 18 Feb 2022 15:25:33 +0100 (CET)
Date:   Fri, 18 Feb 2022 15:25:33 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anthony Iliopoulos <ailiop@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: enable default zlib compression in
 btrfs-image
Message-ID: <20220218142533.GV12643@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anthony Iliopoulos <ailiop@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20220215171213.5173-2-ailiop@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220215171213.5173-2-ailiop@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 15, 2022 at 06:12:13PM +0100, Anthony Iliopoulos wrote:
> The btrfs-image utility supports zlib compression natively, but it is
> disabled by default. Enable it at the zlib-defined default compression
> level (6).

Makes sense to me, I don't think that there's a reason why the dump
should not be compressed.

However this patch breaks the tests, there are several image dumps
with crated data for some test cases, so this needs to be adapted first.
I'm not yet sure what's the problem, will look into it and then apply
this patch. Thanks.
