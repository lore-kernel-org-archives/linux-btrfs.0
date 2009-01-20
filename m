From: Zach Carter <z.carter@f5.com>
Subject: Re: [PATCH] btrfsck: Exit and print error message when not able to open device
Date: Tue, 20 Jan 2009 11:26:00 -0800
Message-ID: <200901201126.00699.z.carter@f5.com>
References: <1232152077-3862-1-git-send-email-cascardo@holoscopio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1232152077-3862-1-git-send-email-cascardo@holoscopio.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 16 January 2009 16:27:57 Thadeu Lima de Souza Cascardo wrote:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf (stderr, "Coult not open %s\n",=
 filename);

"Coult" should be "Could".

Other than that, the patch seems to fix the segfault issue for me.

thanks,

-Zach

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
