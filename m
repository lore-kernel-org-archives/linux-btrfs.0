Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59018 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab2F0CMs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 22:12:48 -0400
Received: by obbuo13 with SMTP id uo13so759429obb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2012 19:12:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFwScO_ENB2tDKpXozCqz09PjH6sCRvDCB-Pr2XJSy2HTerwFQ@mail.gmail.com>
References: <CAFwScO_ENB2tDKpXozCqz09PjH6sCRvDCB-Pr2XJSy2HTerwFQ@mail.gmail.com>
Date: Tue, 26 Jun 2012 21:12:47 -0500
Message-ID: <CAFwScO84-iegX_g7Lc3BRTvbp754s84Pz8BpFAEmbETjsTDkOg@mail.gmail.com>
Subject: Re: waiting for deferred cleanup operations
From: David Nicol <davidnicol@gmail.com>
To: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I see that the #undef spells the macro wrong, so I'll fix that of course too.

On Tue, Jun 26, 2012 at 8:55 PM, David Nicol <davidnicol@gmail.com> wrote:


> The whole picture is in the introduction to the last submitted version
> of the patch,
> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/8668
