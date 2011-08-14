From: Yalonda Gishtaka <yalonda.gishtaka@gmail.com>
Subject: Re: corrupted btrfs volume: parent transid verify failed
Date: Mon, 15 Aug 2011 01:32:18 +0200
Message-ID: <CABqt_RN0+0Wj9qM3sEKR-C76_CeL-sLN5EsVWicuZEJDAp4AZA@mail.gmail.com>
References: <CABqt_RND8Bd8NJ5cniKP=ySBBh6+p_xyoJh9ZL2aJeR9Sb4qrQ@mail.gmail.com>
	<CABqt_RNd55S6fLgm6nteGq7kvgF9D33m4a_7ahNasSug-_tGeA@mail.gmail.com>
	<4E4855FF.2040806@cchtml.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Michael Cronenworth <mike@cchtml.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E4855FF.2040806@cchtml.com>
List-ID: <linux-btrfs.vger.kernel.org>

"Soon" seems a bit subjective given that the devs have been touting
this since the beginning of time.

/Helpful/ advice would be nice.

This blog posting
(http://stujordan.wordpress.com/2011/06/20/churning-the-butter/)
sounded promising, but none of the superblock copies on my btrfs
volume are ok, as I keep receiving the same "parent transid verify
failed" messages.  Will be released btrfsck tool handle this case?

On Mon, Aug 15, 2011 at 1:10 AM, Michael Cronenworth <mike@cchtml.com> wrote:
> On 08/14/2011 04:13 PM, Yalonda Gishtaka wrote:
>>
>> I'm quite desperate
>> to recover this volume.
>
> You should have had backups.
>
> Btrfs has no file system repair tool, but it is supposed to be out soon
> (tm). You will have to wait.
>
