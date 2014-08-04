Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:47056 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbaHDLAD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Aug 2014 07:00:03 -0400
Received: by mail-we0-f173.google.com with SMTP id q58so7504141wes.18
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Aug 2014 03:59:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6565984.JHVfJyxURt@quad>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com>
 <17833067.mzxAL4oqZq@quad> <CAFChkqs3LOM4HmDzpXgs6YTeoXvyNPbsNWCPf74=_MnPneJ+HQ@mail.gmail.com>
 <6565984.JHVfJyxURt@quad>
From: Peter Waller <peter@scraperwiki.com>
Date: Mon, 4 Aug 2014 11:59:19 +0100
Message-ID: <CAFChkqsnRvO9h=kxO8LVnchEN3k5oXUFhsCgGw0qPpaT9ipnjw@mail.gmail.com>
Subject: Re: ENOSPC with mkdir and rename
To: Chris Samuel <chris@csamuel.org>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4 August 2014 11:50, Chris Samuel <chris@csamuel.org> wrote:
> To be honest I'm not sure I'd suggest btrfs for production use at all at
> present, it's only recently been unmarked as experimental and to be honest I
> feel that was premature. :-(

Thanks for the honest answer.

There are very positive signals out there which I had perhaps taken
too literally. I'd love to see it become ready, there are a lot of things
about BTRFS which appeal greatly. So I hope I'm helping by trying
to make it clear the problems that I encountered.
