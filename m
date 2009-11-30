From: jean-philippe robichaud <jean.philippe.robichaud@gmail.com>
Subject: Re: unexpected raid1 behavior?
Date: Mon, 30 Nov 2009 11:20:48 -0500
Message-ID: <679b1ea70911300820m37c04035p113cda74d380f6fc@mail.gmail.com>
References: <200911271541.17451.jean.philippe.robichaud@gmail.com>
	 <200911271736.22930.jean.philippe.robichaud@gmail.com>
	 <20091129124256.GA17897@cumulus>
	 <200911291628.26997.jean.philippe.robichaud@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200911291628.26997.jean.philippe.robichaud@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 29, 2009 at 4:28 PM, Jean-Philippe Robichaud
<jean.philippe.robichaud@gmail.com> wrote:
>
> On Sunday 29 November 2009 07:42:56 Sander wrote:
> > Hello Jean-Philippe,
> >
> > Jean-Philippe Robichaud wrote (ao):
> > > Is there a place in /sys or /proc where I could perhaps get 'stat=
s'
> > > about the btrfs volume?
> >
> > I think btrfs-show should help you there.
> >
> > =A0 =A0 =A0 With kind regards, Sander
> >
> Sure: here it goes:
>
> # sudo btrfs-show
> failed to read /dev/sr0
>
> Label: none =A0uuid: fb9270b4-8779-489f-a599-eaab299d4633
> =A0 =A0 =A0 =A0Total devices 2 FS bytes used 78.98GB
> =A0 =A0 =A0 =A0devid =A0 =A01 size 341.69GB used 146.03GB path /dev/s=
da5
> =A0 =A0 =A0 =A0devid =A0 =A02 size 341.69GB used 146.01GB path /dev/s=
db5
>

I'm not sure I actually understand how to read this.The size of each
device make sense (341GB) as it is the size of both partitions.  Now
the FS-bytes-used also make sense as it is about the size of data that
I've copied, but the per-device used space seems strange to me and the
output of "df -h" is also hard to interpret:

=46ilesystem            Size  Used Avail Use% Mounted on
/dev/sda5             684G   79G  605G  12% /btrfs

I would have understood if the "Used" field would have been 160GB or
if "Avail" would have dropped to 520GB.

I guess that I'll come to a point where Used will be 340GB and Avail
will also be 340GB but I'll be getting No Space Left On Device errors?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
