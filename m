Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A786CC43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 16:17:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 748252087F
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 16:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546964276;
	bh=AFP5jhA0Bb9G1HjzqqCUOuUihk8zVvsN9WwrJVsk/xE=;
	h=References:In-Reply-To:From:Date:Subject:To:List-ID:From;
	b=MbCPV4qyZxBG/PEbRNgF6I7zzoUBdI2RP96YADsHucjevMfwyZsB2Xk3FvTE48Jq4
	 /yfFrJoyPF5G6nuDN/QGrwjn1kS5JgpNj1JxvkW2H7P+1oKkjst+pchvCG007wG53X
	 iFk3JCkoH+q6fn4/SJlyH89S4KqEFmCVD9baR+8Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729190AbfAHQRz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 11:17:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:59838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729172AbfAHQRz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Jan 2019 11:17:55 -0500
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AC95214C6
        for <linux-btrfs@vger.kernel.org>; Tue,  8 Jan 2019 16:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1546964274;
        bh=AFP5jhA0Bb9G1HjzqqCUOuUihk8zVvsN9WwrJVsk/xE=;
        h=References:In-Reply-To:From:Date:Subject:To:From;
        b=sefQ7ucN3vzGIhrQm3nnq6HXLlGlUA3/SkPO0qGrWKSdydKRdGJ5rM7At72vsy5fI
         srbwfTiqYU9wBKg3i/kLx6C9F8Sp0q47SVRD84XJk4FAThSSz7nxBvuvs5T2HhNy9T
         kN14OjRTN0Y2nUMhv25ap0aHU1OISFewBCS5f2bc=
Received: by mail-vs1-f50.google.com with SMTP id h78so2811438vsi.6
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Jan 2019 08:17:54 -0800 (PST)
X-Gm-Message-State: AJcUukdeXpJXqjeUI0nRSThhsZvHu8FP3T7axyPH8masx0DsEQ106a/v
        lT9QMVK6j7XYkC+PR5R1RDc2SSQjI2vBF1GUtLs=
X-Google-Smtp-Source: ALg8bN7Xsd/N3JEx8NMJhyzm/PY0/AUp5tCYp7WPEtKriqS5AF7OKwQQOyyWHxQGGFBdibkVTkHvSc0r8bS8jqT2Dlg=
X-Received: by 2002:a67:c806:: with SMTP id u6mr964362vsk.206.1546964272978;
 Tue, 08 Jan 2019 08:17:52 -0800 (PST)
MIME-Version: 1.0
References: <20190108114441.5573-1-fdmanana@kernel.org> <20190108161409.GL23615@twin.jikos.cz>
In-Reply-To: <20190108161409.GL23615@twin.jikos.cz>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Tue, 8 Jan 2019 16:17:41 +0000
X-Gmail-Original-Message-ID: <CAL3q7H572Y9TeO8HEUYYDmNH=_PtuGvPBk7MoYD5EjjXedhvTw@mail.gmail.com>
Message-ID: <CAL3q7H572Y9TeO8HEUYYDmNH=_PtuGvPBk7MoYD5EjjXedhvTw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix deadlock when using free space tree due to
 block group creation
To:     dsterba@suse.cz, Filipe Manana <fdmanana@kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 8, 2019 at 4:14 PM David Sterba <dsterba@suse.cz> wrote:
>
> On Tue, Jan 08, 2019 at 11:44:41AM +0000, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > When modifying the free space tree we can end up COWing one of its extent
> > buffers which in turn might result in allocating a new chunk, which in
> > turn can result in flushing (finish creation) of pending block groups. If
> > that happens we can deadlock because creating a pending block group needs
> > to update the free space tree, and if any of the updates tries to modify
> > the same extent buffer that we are COWing, we end up in a deadlock since
> > we try to write lock twice the same extent buffer.
> >
> > So fix this by skipping pending block group creation if we are COWing an
> > extent buffer from the free space tree. This is a case missed by commit
> > 5ce555578e091 ("Btrfs: fix deadlock when writing out free space caches").
> >
> > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=202173
> > Fixes: 5ce555578e091 ("Btrfs: fix deadlock when writing out free space caches
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
>
> Lighweight Reviewed-by, as the bug is in 4.19.x I'm going to push the
> fix to 5.0. Thanks.

The bug is in any kernel with free space tree support. In order to fix
it (apply this patch), the commit mentioned
in the Fixes tag is a dependency (it's not regression from that
commit, it simply didn't fix that case).
