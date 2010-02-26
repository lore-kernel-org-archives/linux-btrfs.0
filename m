From: Gustavo Alves <gjalves@gjalves.com.br>
Subject: Re: assertion failures
Date: Fri, 26 Feb 2010 16:57:27 -0300
Message-ID: <69e11d1f1002261157x1b305776w96f6bfcef4b8ae2f@mail.gmail.com>
References: <20100225004004.GK25641@think>
	 <20100225140420.4EBA940954@viridian.itc.virginia.edu>
	 <69e11d1f1002251028s3df20904yb9e90be36c883bbe@mail.gmail.com>
	 <20100226161332.GA12841@think> <20100226161523.GB12841@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100226161523.GB12841@think>
List-ID: <linux-btrfs.vger.kernel.org>

In my case, kernel 2.6.32-0.51.rc7.git2.fc13.i686.PAE and BTRFS under L=
VM2.

----
Gustavo Junior Alves
Specchio Solu=E7=F5es em TI


On Fri, Feb 26, 2010 at 1:15 PM, Chris Mason <chris.mason@oracle.com> w=
rote:
> On Fri, Feb 26, 2010 at 11:13:32AM -0500, Chris Mason wrote:
>> On Thu, Feb 25, 2010 at 03:28:19PM -0300, Gustavo Alves wrote:
>> > I've got the same error before in a similar situation (24 partitio=
ns,
>> > only two with problems). Unfortunally I erased all data after this
>> > error. Strange that all I've done was shutdown and poweron the
>> > machine.
>>
>> Basically it looks like the tree of data checksums isn't right. =A0W=
hich
>> kernels were you running when you had these problems?
>
> Sorry, I mixed up this corruption with one farther down. =A0The same
> question stands though, this error generally means that IO either did=
n't
> happen or happened in the wrong place.
>
> So, the more details you can give about your config the easier it wil=
l
> be to nail it down.
>
> -chris
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
