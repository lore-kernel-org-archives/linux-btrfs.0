From: Palmer Cox <palmercox@gmail.com>
Subject: bcp command not installed by Makefile
Date: Thu, 10 Jun 2010 21:46:11 -0400
Message-ID: <AANLkTimRn1NJsivc6HD8W5K3QKQoPdmvfK54o6TOY37c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Is there a reason the bcp command isn't installed when running make
install? =A0If not, here is a really simple patch to add it to the
install.

-Palmer Cox


diff --git a/Makefile b/Makefile
index 525676e..e5005b0 100644
--- a/Makefile
+++ b/Makefile
@@ -93,6 +93,7 @@ clean :
=A0install: $(progs) install-man
=A0=A0 =A0 =A0 =A0$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
=A0=A0 =A0 =A0 =A0$(INSTALL) $(progs) $(DESTDIR)$(bindir)
+ =A0 =A0 =A0 $(INSTALL) -m755 bcp $(DESTDIR)$(bindir)
=A0=A0 =A0 =A0 =A0if [ -e btrfs-convert ]; then $(INSTALL) btrfs-conver=
t
$(DESTDIR)$(bindir); fi

=A0-include .*.d
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
