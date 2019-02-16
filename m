Return-Path: <SRS0=6oD6=QX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 424DEC43381
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Feb 2019 00:17:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0578E2192D
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Feb 2019 00:17:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="ZR5ZFLVv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388376AbfBPARj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Feb 2019 19:17:39 -0500
Received: from mail-lj1-f181.google.com ([209.85.208.181]:43644 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbfBPARj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Feb 2019 19:17:39 -0500
Received: by mail-lj1-f181.google.com with SMTP id z20so8796483ljj.10
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Feb 2019 16:17:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xYEuM6azaqdH4p+bq0a2CYYpJrr/tW9UmDlQmEBUQkk=;
        b=ZR5ZFLVvrg5b6LpjWeK9mJgzIQ71z57aDKpKsCEfoVzVy4+LHEAUyg8GS7Isu5JKOH
         0DPaeFiK1DYqiYV/9YbYAJQVtDiqzHKBNbrxpJAJslqIF+I5qkJKEp50ElXabNFLs9ah
         E9Ew6t39KxKPMJ6HCqMNEeX3H3I3TqPC2Me4biQuSivbgZ0d4IrXY+FG/dXVVEkK6bdn
         R6KmuS8UZ7h43CuxRo4Yu8tC65f1UE9sR6QH8iNM/xUsr2ns+doMXLE1Sl1G9OYrRzHY
         MxcWgUSMAErRr9MxIogFqceMi62bPK7GPALn38rC/ZkRzkmkwfEVF6zSOOXo/xfKtler
         iRiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xYEuM6azaqdH4p+bq0a2CYYpJrr/tW9UmDlQmEBUQkk=;
        b=RPOibxbIXyp1XRnqKYpTqdbl3oEmP0AAOPY2VK+QJ/VFyeLKoVHNKM2zq/QmKoOSd/
         WLKvbnQP5iQfqRuhAHs17JwVnruApsvJ0vTVLCDwitvuOPtGZWPda+Mfsz2EDV1LuguV
         7JvAJq+SulD1+P3zDGZkOm92jbkNROu8AN9gQF1m1wgl1H+Dq3E8BTCCvShXWpV0aBxS
         aYGrZhS+A02pyq6rQ4AVpTqonX8S/fscXZFg0jl1GyuCbCBocNkSkQtAUzdZPT7XAjui
         nyicbWS7JJgp1seoQP9/ogzpkidoxe203Ysg1npYsDsEj56Qop9vshPEx+5EpJ4YKGPR
         bTfA==
X-Gm-Message-State: AHQUAub0qhqWJDo05EBmbLoEnwUx5cZ5I0FsnG6cr3TakEO6Fg6ef2Tr
        x98mbZEGlmFUW0d/LZHSqf2jJQPMK2kqwyQk0FIBpIGg
X-Google-Smtp-Source: AHgI3IaqQbj8QHSURuJExc6nSRExIK8NBVN5IB8S7pVZv6WuTEGDUumu6vevh3ZvfZXgt0yX+d+bK9ObybJr1gGJZ8M=
X-Received: by 2002:a2e:9983:: with SMTP id w3mr6056587lji.71.1550276257345;
 Fri, 15 Feb 2019 16:17:37 -0800 (PST)
MIME-Version: 1.0
References: <CAG245DUfS_cXvDZguyE76bPprY8Y1_f+FymHnGjYqkUq_qWbnQ@mail.gmail.com>
In-Reply-To: <CAG245DUfS_cXvDZguyE76bPprY8Y1_f+FymHnGjYqkUq_qWbnQ@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Fri, 15 Feb 2019 17:17:25 -0700
Message-ID: <CAJCQCtRjCcxt9_r+iR9J5jPY1oV8UOAvhSp6r6MNZm4jFJfEpw@mail.gmail.com>
Subject: Re: Btrfs corruption: Cannot mount partition
To:     =?UTF-8?Q?Martin_P=C3=B6hlmann?= <mpdeimos@gmail.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Feb 15, 2019 at 2:31 PM Martin P=C3=B6hlmann <mpdeimos@gmail.com> w=
rote:


OK I just looked at the dmesg you attached, and you might have found a bug.


1.
Try -o ro,nologreplay because it's safe, and you can update your
backups if needed.
2.
If ro,nologreplay doesn't work, use 'btrfs restore' to extract
important files. The point here is to be prepared to lose the file
system before it's actually lost.
3.
Try to mount normally (no mount options) with a different kernel. If
it were me I would try in order:
5.0.0-rc6
4.19.23
4.14.101

4. If none of those kernels will mount it normally, wait if you can.
But once you need to move on you can try to zero the log as described
and then try a normal mount. If mount still fails but with different
messages, report back. It might be possible once zero log is run, to
use a backup root, or do a check using a specific root tree. But if
you're at this point, it's close to check --repair time and that can
sometimes make things worse.



--=20
Chris Murphy
