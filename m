From: Freddie Cash <fjwcash@gmail.com>
Subject: Re: Various Questions
Date: Sat, 8 Jan 2011 17:26:25 -0800
Message-ID: <AANLkTi=HPx1-e09kPg0c6_UQpTCOfPe6-Q4SOUxKLnE=@mail.gmail.com>
References: <201101070915.20468.CACook@quantum-sci.com>
	<AANLkTinCSW-JpwYPYNNAaxHnvXqAy02fMr=Hd34CGxh3@mail.gmail.com>
	<201101071055.44187.CACook@quantum-sci.com>
	<201101080525.19792.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Carl Cook <CACook@quantum-sci.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101080525.19792.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 8, 2011 at 5:25 AM, Carl Cook <CACook@quantum-sci.com> wrot=
e:
>
> In addition to the questions below, if anyone has a chance could you =
advise on why my destination drive has more data =C2=A0than the source =
after this command:
> # rsync --hard-links --delete --inplace --archive --numeric-ids /medi=
a/disk/* /home
> sending incremental file list

What happens if you delete /home, then run the command again, but
without the *?  You generally don't use wildcards for the source or
destination when using rsync.  You just tell it which directory to
start in.

If you do an "ls /home" and "ls /media/disk" are they different?

--=20
=46reddie Cash
fjwcash@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
