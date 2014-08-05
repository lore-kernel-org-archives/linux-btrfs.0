Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:62013 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbaHENDC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Aug 2014 09:03:02 -0400
Received: by mail-wi0-f182.google.com with SMTP id d1so1270433wiv.3
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Aug 2014 06:02:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFvQSYQhGhoRXWQ4Wqb7LZd3tdx8wLHDxn1uMqNEij8=yEvf1A@mail.gmail.com>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com>
 <1875052.8GFlAMfPzL@quad> <pan$dbb9d$e1133995$a123d619$8316b9ab@cox.net>
 <5484676.xyTNESz9qN@xev> <CAFvQSYQhGhoRXWQ4Wqb7LZd3tdx8wLHDxn1uMqNEij8=yEvf1A@mail.gmail.com>
From: Peter Waller <peter@scraperwiki.com>
Date: Tue, 5 Aug 2014 14:02:16 +0100
Message-ID: <CAFChkqsUnHroia-kRH8rp4sHEwf8MaYhMOpjtMUX0wkNy6nxrA@mail.gmail.com>
Subject: Re: ENOSPC with mkdir and rename
To: Clemens Eisserer <linuxhippy@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 5 August 2014 13:58, Clemens Eisserer <linuxhippy@gmail.com> wrote:
> As long as it is not selected as the default filesystem, I think it is fine.
> Other distributions have been offering btrfs for some time now, too.

How do you warn non-BTRFS-developers in this case that they need to
run a regular rebalance or they may end up in a
difficult/expensive/impossible to fix ENOSPC condition at an
inconvenient moment?
