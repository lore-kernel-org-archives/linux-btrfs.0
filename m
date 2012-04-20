From: Avi Kivity <avi.kivity@gmail.com>
Subject: Re: Problems with nodatacow/nodatasum
Date: Fri, 20 Apr 2012 12:22:11 +0300
Message-ID: <CAEbWaiqfh9KBM5U0QtqULHwLed854MeY=cPSxWRhoEGND9ve0A@mail.gmail.com>
References: <CAEbWaipj_MzfM2wF6CpQg5dNCmLNLVomReDmnBVZHv9R3Be-cw@mail.gmail.com>
	<20120420091250.GK20982@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: dave@jikos.cz, Avi Kivity <avi.kivity@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120420091250.GK20982@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 20, 2012 at 12:12 PM, David Sterba <dave@jikos.cz> wrote:
> On Fri, Apr 20, 2012 at 11:19:39AM +0300, Avi Kivity wrote:
>> =A0 /dev/mapper/luks-blah / =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 btrfs
>> subvol=3D/rootvol =A0 =A0 =A0 =A01 1
>> =A0 /dev/mapper/luks-blah /var/lib/libvirt/images =A0 =A0 btrfs
>> nodatasum,nodatacow,subvol=3D/images.libvirt =A0 =A0 =A0 =A01 2
>
> what does /proc/mounts say about the applied options? do you see
> nodatasum and nodatacow there? afaik most (if not all) mount options
> affect the whole filesystem including any subvolume mounts. =A0having
> per-subvol options is possible, just not implemented.
>

Nothing, the options don't show up there.

Are there plans to allow per-subvolume nodatasum/nodatacow?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
