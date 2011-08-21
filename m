From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] Btrfs: use do_div to avoid compile errors on 32bit box
Date: Sat, 20 Aug 2011 18:04:51 -0700
Message-ID: <CA+55aFzm67yfdnwu9ou6X6zf05DyiGvCD0ci8vZM97W+B_HMoQ@mail.gmail.com>
References: <1313806667-30495-1-git-send-email-liubo2009@cn.fujitsu.com> <4E4FA6D8.7030407@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Liu Bo <liubo2009@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
	mingo@kernel.org, jwboyer@gmail.com, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com, dave@jikos.cz
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4E4FA6D8.7030407@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 20, 2011 at 5:21 AM, Josef Bacik <josef@redhat.com> wrote:
>
> I think Linus was less complaining about how you're dividing here and
> more about the fact that you are. =A0A divide by 2 is the same as a >=
> 1.
> =A0I'll send a patch to fix this. =A0Thanks,

Indeed. A single-bit 64-bit "double shift" may be a few cycles, but
it's still pretty damn cheap. Especially when compared to a 64x32 bit
divide. We absolutely don't want to do "do_div()" in order to divide
by the constant 2.

                     Linus
