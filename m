From: Dante <danteinbrisbane@gmail.com>
Subject: Re: Any chance to recovery btrfs raid-0 after accidental format of
 one volume?
Date: Tue, 6 Sep 2011 07:56:02 +1000
Message-ID: <CAKdoYmAsSa5Qdp_S_XrhVjHyDhGwmNcH=Vw0wFq0oRMvm0medA@mail.gmail.com>
References: <CAKdoYmDNjBDgHjLNaf5HmrRxGkYPXjssZoGa3Tb4p3uc2DcOcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKdoYmDNjBDgHjLNaf5HmrRxGkYPXjssZoGa3Tb4p3uc2DcOcg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Bad case of user error here but I managed to reformat one half of a
btrfs volume that was set up with metadata raid-1 and data raid-0.

I can mount the remaining half degraded, and can see all of the files,
but half their content is missing.

I=92m just wondering whether, since all the metadata is intact, and
since (most of) the data on the partition that I reformatted has not
actually been over-written, whether it is conceivable that I can
recover most of my files by somehow reincorporating the second volume
into the array?

The important stuff is all backed up (I hope) so this is more of
academic interest...
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
