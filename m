Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58406 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760783Ab2FDPd5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jun 2012 11:33:57 -0400
Received: by dady13 with SMTP id y13so5975314dad.19
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jun 2012 08:33:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGEjNMf5hU4wteJepU5h4r=HXs_Anf_RGawHpphq=ft76Raw=Q@mail.gmail.com>
References: <CAHf9xvYX+3sjJL3anEQD0TJLbBiSsF4Pu1aBwVjeTofNmxFMpw@mail.gmail.com>
	<CAB9VWqAoc=+9B5FLtVbDY8xWeRt+O8oJ79BQKtdhOMjMAYu2eA@mail.gmail.com>
	<CAGEjNMf5hU4wteJepU5h4r=HXs_Anf_RGawHpphq=ft76Raw=Q@mail.gmail.com>
Date: Mon, 4 Jun 2012 17:33:56 +0200
Message-ID: <CAB9VWqAbh1GEbbvbm0MjOPCocX3K7B5yVynH1VYMWV-rN_CZ7Q@mail.gmail.com>
Subject: Re: inquiry on btrfs send/receive
From: Alexander Block <ablock84@googlemail.com>
To: shyam btrfs <shyam.btrfs@gmail.com>
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 4, 2012 at 5:10 PM, shyam btrfs <shyam.btrfs@gmail.com> wrote:
> Hi Alex, Jan,
>
> I was also interested in send/receive semantics & was thinking that if
> we adhere to the semantics as in
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg07482.html
> of:
>
> it is impossible to track the "deleted" items (files,dirs, eXtended
> attributes). I can develop a command which compare two subvolumes an
> extract all of this kind of information. But this command would return
> correct information *only if*
>   A) a subvolume is a snapshot of the other one
>   B.1) the reference snapshot is not touched OR
>   B.2) I have the lastgen "when" the snapshot is taken
What I implement is basically the same, but with no transid involved. The
comparison however takes place inside the kernel and not in user space.
>
> then transid/generation number could be made to work to determine the
> differences between two subvolumes including the deletes that were
> involved. I agree that file-clone is tricky as you pointed, but we
> dont use it in our environment.
>
> Do you still see issues with it that I am missing?
>
> Also out of curiosity, would you mind sharing how you avoided looking
> at transid? Would it be that all meta changes are logged in
> tree-modification-log or equivalent?
The btrees in btrfs have a nice feature: If you compare two trees and
encounter a tree block that is shared with the other tree, the whole
subtree below is shared and thus can be regarded as unchanged.
Checking the transids does not guarantee that you skip those
unchanged subtrees, as the transids may also change when none
of the items change. btrfs balance may do this for example. So you
would unnecessarily iterate and compare the whole tree in many
cases, which will give bad performance.
