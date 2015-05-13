Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:34481 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbbEMQYi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 12:24:38 -0400
Received: by oiko83 with SMTP id o83so35416329oik.1
        for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2015 09:24:37 -0700 (PDT)
MIME-Version: 1.0
From: Learner Study <learner.study@gmail.com>
Date: Wed, 13 May 2015 09:24:17 -0700
Message-ID: <CAP8+hKVLpwT7fFqMods0++SKqQSXF5Z1tXNcAgFw_i3utfFeVQ@mail.gmail.com>
Subject: de-duplication algos
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Learner Study <learner.study@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have been reading on de-duplication and how algorithms such as Bloom
and Cuckoo filters are used for this purpose.

Does BTRFS dedup use any of these, or are there plans to incorporate
these in future?

Thanks for your guidance!
