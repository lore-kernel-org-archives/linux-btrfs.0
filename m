From: Chester <somethingsome2000@gmail.com>
Subject: Re: Set nodatacow per file?
Date: Mon, 13 Feb 2012 01:34:52 -0600
Message-ID: <CAAE6i0iHNnr7=BjFOWd8hR99jKKVAfGcFo5GKHLnT6nytWn7jA@mail.gmail.com>
References: <4F38B8F0.5020506@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Ralf-Peter Rohbeck <rohbeck@yahoo.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F38B8F0.5020506@yahoo.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2012 at 1:17 AM, Ralf-Peter Rohbeck <rohbeck@yahoo.com>=
 wrote:
>
> Hello,
> is it possible to set nodatacow on a per-file basis? I couldn't find =
anything.
> If not, wouldn't that be a great feature to get around the performanc=
e issues with VM and database storage? Of course cloning should still c=
ause COW.

IIRC this is already a feature in btrfs. I didn't catch the whole
talk, but Chris mentioned something like this at Scale 10x. I also
remember seeing a patch for it a while back (I think it was from liu
bo) that does this.

>
> Thanks,
> Ralf-Peter
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
