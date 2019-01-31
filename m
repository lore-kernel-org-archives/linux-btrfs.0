Return-Path: <SRS0=M3t6=QH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B2BBC169C4
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 16:17:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C0DD2085B
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 16:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548951454;
	bh=LCfa1J8YYG+ivrS0LOxsO11ZbFdQIy5fYkzykCHZU8k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=NPOS8Tf9uI8wKh+qBInNhTmYz6KzjxYVThUJYZxK6m+99rYy0zClpGLvwhF28r/Ps
	 UbNC3dJWWRMfgZ6fR6mwC09/EP6pUSSPrs8g4rhBIeIYteNxCqTWlBsHOP1csqtZ9A
	 B/Jgq9p11b9eHvPLw6S15UjsLXC88XwTsbkVbYZM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388241AbfAaQR2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 31 Jan 2019 11:17:28 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:42672 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388155AbfAaQR2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Jan 2019 11:17:28 -0500
Received: by mail-yw1-f68.google.com with SMTP id x2so1471783ywc.9;
        Thu, 31 Jan 2019 08:17:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XkwLXcoRkVmgZPav9GtqCHyR/6Nz/q92jkOChgvBD2k=;
        b=L3iLjIbVbwFRaHukD53iUWOTuEaiUyVjOJ6r7gMQzQ+kv4ePOgfR846Iwfxgtpq5av
         AUIm4Y01r+A2jj4fe37uLSlq6uslp9SpY6q0dRxKlsXMC77H1PsJQwncd4cw97QENRCn
         bTQTVXKswZ+lB/MgAmwkIHWWuyHa6TyjYji1EaAi0C+dnYH25VJsh4aVWJeMKYG4Am/D
         wuXIDYqmBC+Oxs385isSo11A9rsjhMdTkWNabkxdJ9orkUT/bv8ceBZCIkb7EWhtgo3p
         0yeY849XHoHhQLJdmM8Naze9sCXNnoJ62OqQ8qq48Ko2pI67h19lOkwlO33NfeVn3gA1
         5nuQ==
X-Gm-Message-State: AJcUukeKplxDxO8AG/PkUcJ8qTNfyEXV6sc7M1P//3tDFncn+iXgHbvQ
        uy8C0SpjT33/o47Jn7zYECk=
X-Google-Smtp-Source: ALg8bN6no8Bwmutzs2k8DfLEB/yGQuY0A5wmnExAAXe9YLMMQPINU61wmhjafg3499IShkUIsboalQ==
X-Received: by 2002:a81:d303:: with SMTP id y3mr34241577ywi.502.1548951447420;
        Thu, 31 Jan 2019 08:17:27 -0800 (PST)
Received: from dennisz-mbp ([2620:10d:c091:200::6:84c2])
        by smtp.gmail.com with ESMTPSA id o14sm3425503ywo.52.2019.01.31.08.17.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Jan 2019 08:17:26 -0800 (PST)
Date:   Thu, 31 Jan 2019 11:17:24 -0500
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.cz>
Cc:     Dennis Zhou <dennis@kernel.org>, David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] btrfs: add macros for compression type and level
Message-ID: <20190131161724.GA93554@dennisz-mbp>
References: <20190128212437.11597-1-dennis@kernel.org>
 <20190128212437.11597-2-dennis@kernel.org>
 <20190131160010.GK2900@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190131160010.GK2900@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 31, 2019 at 05:00:10PM +0100, David Sterba wrote:
> On Mon, Jan 28, 2019 at 04:24:27PM -0500, Dennis Zhou wrote:
> > It is very easy to miss places that rely on a certain bitshifting for
> > decyphering the type_level overloading. Make macros handle this instead.
> 
> This encoding was a simple way to introduce the combined type and level
> for zlib and it could certainly be improved. Either we'll use helpers
> like you suggest or add a new structure that contains type and level as
> members. That way we'd see where the level still matters and where the
> just the type is ok.
> 
> I haven't checked how much intrusive this would be, so that's for later
> consideration. Some indirection can be removed for the .set_level
> callbacks as it does not necessarily need to be a function so I'm
> expecting that the code around that would be touched anyway.

The only user of type_level is btrfs_compress_pages(). I do make an
extra call to .set_level() there just to be safe, but that can be taken
out as it should be correctly set from when we mounted.

I envisioned .set_level() to be called when setting the compression
level of the mount. This can be used in the same place if we were to add
per-file compression levels too. I mention later, but an important part
of .set_level() is to repurpose the meaning of 0 from meaning use the
default to meaning use any workspace available.

Thanks,
Dennis
