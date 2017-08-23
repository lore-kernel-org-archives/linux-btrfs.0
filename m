Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37268 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932111AbdHWRzQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 13:55:16 -0400
Received: by mail-wm0-f51.google.com with SMTP id b189so4285501wmd.0
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Aug 2017 10:55:16 -0700 (PDT)
From: Diego Calleja <diegocg@gmail.com>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 4/6] Btrfs: heuristic add detection of zeroed sample
Date: Wed, 23 Aug 2017 19:55:12 +0200
Message-ID: <4756671.4QeJesEyyX@archlinux>
In-Reply-To: <20170823002650.3133-5-nefelim4ag@gmail.com>
References: <20170823002650.3133-1-nefelim4ag@gmail.com> <20170823002650.3133-5-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

El miércoles, 23 de agosto de 2017 2:26:48 (CEST) Timofey Titovets escribió:
> +	for (i = 0; i < workspace->sample_size; i += sizeof(zero)) {
> +		if (memcmp(&workspace->sample[i], &zero, sizeof(zero)))
> +			return false;

Instead of just checking for 0, wouldn't it be a better idea to check
for any kind of repetitions?

As in, iterate over the sample and memcmp() each part of sample with
the previous one. The cost would be the same, and it would detect not
just zeros, but any kind of repeated data. Is there any reason I'm
missing for not doing this?
