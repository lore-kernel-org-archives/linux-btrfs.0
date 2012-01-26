From: Chester <somethingsome2000@gmail.com>
Subject: Re: Will BTRFS repair or restore data if corrupted?
Date: Thu, 26 Jan 2012 01:19:15 -0600
Message-ID: <CAAE6i0j2RQY7JF2vqZtmS1n_AnEBG2oLzVtQwjfYwWLRULt78w@mail.gmail.com>
References: <4F208FFD.4020508@online.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Waxhead <waxhead@online.no>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F208FFD.4020508@online.no>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 25, 2012 at 5:27 PM, Waxhead <waxhead@online.no> wrote:
> Hi,
>
> From what I have read BTRFS does replace a bad copy of data with a kn=
own
> good copy (if it has one). Will BTRFS try to repair the corrupt data =
or will
> it simply silently restore the data without the user knowing that a f=
ile has
> been "fixed"?
=46rom what I've seen, it'll quietly restore the data without the user
knowing. The only indication would be in dmesg where there should be a
message about incorrect checksums and btrfs fixing it automatically.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
