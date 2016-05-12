Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36361 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbcELU4s (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 16:56:48 -0400
Received: by mail-wm0-f67.google.com with SMTP id w143so18048481wmw.3
        for <linux-btrfs@vger.kernel.org>; Thu, 12 May 2016 13:56:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160512112916.GN29353@twin.jikos.cz>
References: <1463010636-18514-1-git-send-email-nsteeves@gmail.com>
	<20160512112916.GN29353@twin.jikos.cz>
Date: Thu, 12 May 2016 16:56:46 -0400
Message-ID: <CAD=QJKhQHeL5JnA+X1=e2DPqHS5UXVyPsDgaGMoTM15CyyCpLQ@mail.gmail.com>
Subject: Re: [PATCH 0/1] btrfs-progs: Typo review of strings and comments
From: Nicholas D Steeves <nsteeves@gmail.com>
To: dsterba@suse.cz, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12 May 2016 at 07:29, David Sterba <dsterba@suse.cz> wrote:
> On Wed, May 11, 2016 at 07:50:35PM -0400, Nicholas D Steeves wrote:
>> There were a couple of instances where I wasn't sure what to do; I've
>> annotated them, and they are long lines now.  To find them, search or
>> grep the diff for 'Steeves'.
>
> Found and updated, most of them real typos, 'strtoull' is name of a C
> library functioon.

Hi David,

Thank you for reviewing this patch.  Sorry for missing the context of
the strtoull comment; I should have been able to infer that and am
embarrassed that I failed to.  Also, embarrassed because I think I've
used it in some C++ code!

I learned how to use git rebase and git reset today, and can submit a
v2 patch diffed against master at your earliest convenience.  My only
remaining question is this:

mkfs.c: printf:("Incompatible features:  %s", features_buf)
  * Should this be left as "Imcompat features"?

Regards,
Nicholas
