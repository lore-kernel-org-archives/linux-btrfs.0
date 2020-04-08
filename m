Return-Path: <SRS0=tPet=5Y=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 748E2C2D0F4
	for <linux-btrfs@archiver.kernel.org>; Wed,  8 Apr 2020 17:46:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53D2320784
	for <linux-btrfs@archiver.kernel.org>; Wed,  8 Apr 2020 17:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586367976;
	bh=XzVojw0yur0MPaSQSycTWh9Tr2gtEudPzTKhZwA26Kc=;
	h=References:In-Reply-To:From:Date:Subject:To:List-ID:From;
	b=MY8DQ8eZ7MVGINws3nc2xhioNeeUzBxiMh8IIKosDN76MHyADs4ZGHMIKKuJde3/A
	 T8ruJtZ4Oe9gy0dWv0A517Iiaz79dWnBepGY0jcNfRVU77KBOmTuPBjvGGvGWl075i
	 FvzEYxXdyyqbsMhGAeA7XBGeS0DdEO2QwMJINyFs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729595AbgDHRqP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 8 Apr 2020 13:46:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727028AbgDHRqP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Apr 2020 13:46:15 -0400
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69E4D20768
        for <linux-btrfs@vger.kernel.org>; Wed,  8 Apr 2020 17:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586367974;
        bh=XzVojw0yur0MPaSQSycTWh9Tr2gtEudPzTKhZwA26Kc=;
        h=References:In-Reply-To:From:Date:Subject:To:From;
        b=oLyWyZP+nX9wS5TVO4SeXHKyr4t+EmVCV9FWoD4QKy1XFC5ZFCLmkMbNPzVMd6zk0
         Up7I+6pfCldLIjIGUKaUBXRBdD9/qdyDibs3YjjSrul3TvrIL45ihVXT3q0j/1BOA4
         Hn9Sc0aM2YiN/eylExZ+Poyx9meY8Y11BS7at3LU=
Received: by mail-vs1-f43.google.com with SMTP id o3so5239252vsd.4
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Apr 2020 10:46:14 -0700 (PDT)
X-Gm-Message-State: AGi0PuYuPmgYSuF5VaxXKpqYELy38eHP39XkiVJdNamYnVKOwhJBsoKX
        KzhTa6LaS1lFpDXK/uwyonxY9sq33sW59vhdNf0=
X-Google-Smtp-Source: APiQypLoSJUVap2eB/rzrY5GDLUSzrzLZpNEXrufNceU4ETyyvO/ubV9hUC/Ir1BxLsvGG/Xy2Mt7QXQ1+o4ep7HFmo=
X-Received: by 2002:a67:ffd3:: with SMTP id w19mr6717716vsq.90.1586367973502;
 Wed, 08 Apr 2020 10:46:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200407103744.5960-1-fdmanana@kernel.org> <20200408170636.GY5920@twin.jikos.cz>
In-Reply-To: <20200408170636.GY5920@twin.jikos.cz>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Wed, 8 Apr 2020 18:46:01 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7okkt33jOZejLa0H1+q77=vYo2EGV7UDfWPhPZD_cxxg@mail.gmail.com>
Message-ID: <CAL3q7H7okkt33jOZejLa0H1+q77=vYo2EGV7UDfWPhPZD_cxxg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: make full fsyncs always operate on the entire file again
To:     dsterba@suse.cz, Filipe Manana <fdmanana@kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 8, 2020 at 6:07 PM David Sterba <dsterba@suse.cz> wrote:
>
> On Tue, Apr 07, 2020 at 11:37:44AM +0100, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
>
> I've put the note about revert at the beginning, fixed the comment
> formatting in btrfs_sync_file, and updated the parameters of

I totally missed that when looking at the diff in a console, don't
know what happened.

> copy_inode_items_to_log in btrfs_log_inode so the diff against
> 0a8068a3dd4294 minimal.

Sounds good.

Thanks.

>
> > Fix this by reverting commit 0a8068a3dd4294 ("btrfs: make ranged full fsyncs
> > more efficient") since there is no easy way to work around it.
>
> Oh well, you tried and that's appreciated, but the fsync matters are
> undoubtedly complicated. Patch added to misc-next and will go to
> upcoming rc, thanks.
