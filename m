From: "krzf83@gmail.com " <krzf83@gmail.com>
Subject: Re: is space really freed after deleting large subvolume?
Date: Thu, 13 Oct 2011 18:57:37 +0200
Message-ID: <CAJ1PRSmHecopafvi_oXDjeSFntZHWH2a714usf7ujrUA14SHCQ@mail.gmail.com>
References: <CAJ1PRSmDmd4mrUaQAhjCt1SMtVaBVxq3dCVjCuT20Y4Wf+Ch+Q@mail.gmail.com>
	<20111013162104.GG21931@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>,
	"krzf83@gmail.com" <krzf83@gmail.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111013162104.GG21931@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

> =A0 No, subvolume deletion is done in the background, and the space
> recovered will be returned for use relatively slowly. This is because
> the FS has to go through the metadata, updating reference counts for
> each extent in the subvolume to work out whether the space can be
> recovered or not.
>

And what affect this rate of space reclaiming? When does it happen?
Also I guess that if it happens it must lower overall io performance
and rise loadavg ...?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
